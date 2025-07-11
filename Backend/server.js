const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');
const path = require('path');

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// MongoDB Connection
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/booklibrary', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => {
  console.log('✅ Connected to MongoDB');
})
.catch((err) => {
  console.error('❌ MongoDB connection error:', err);
});

// Book Schema
const bookSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Book title is required'],
    trim: true,
    maxlength: [200, 'Title cannot be more than 200 characters']
  },
  author: {
    type: String,
    required: [true, 'Author name is required'],
    trim: true,
    maxlength: [100, 'Author name cannot be more than 100 characters']
  },
  publishedYear: {
    type: Number,
    min: [1000, 'Published year must be at least 1000'],
    max: [new Date().getFullYear() + 1, 'Published year cannot be in the future']
  },
  image: {
    type: String,
    default: 'assets/libro.jpg'
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});

// Add indexes for better performance
bookSchema.index({ title: 1, author: 1 });
bookSchema.index({ createdAt: -1 });

const Book = mongoose.model('Book', bookSchema);

// Routes

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'Book Library API is running',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// Get all books
app.get('/api/books', async (req, res) => {
  try {
    const { page = 1, limit = 50, search, sortBy = 'createdAt', sortOrder = 'desc' } = req.query;
    
    // Build query
    let query = {};
    if (search) {
      query = {
        $or: [
          { title: { $regex: search, $options: 'i' } },
          { author: { $regex: search, $options: 'i' } }
        ]
      };
    }

    // Build sort object
    const sort = {};
    sort[sortBy] = sortOrder === 'desc' ? -1 : 1;

    // Execute query with pagination
    const books = await Book.find(query)
      .sort(sort)
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .exec();

    // Get total count for pagination
    const total = await Book.countDocuments(query);

    res.json({
      success: true,
      data: books,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(total / limit),
        totalBooks: total,
        hasNextPage: page * limit < total,
        hasPrevPage: page > 1
      }
    });
  } catch (error) {
    console.error('Error fetching books:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch books',
      error: error.message
    });
  }
});

// Get a single book by ID
app.get('/api/books/:id', async (req, res) => {
  try {
    const book = await Book.findById(req.params.id);
    
    if (!book) {
      return res.status(404).json({
        success: false,
        message: 'Book not found'
      });
    }

    res.json({
      success: true,
      data: book
    });
  } catch (error) {
    console.error('Error fetching book:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch book',
      error: error.message
    });
  }
});

// Create a new book
app.post('/api/books', async (req, res) => {
  try {
    const { title, author, publishedYear, image } = req.body;

    // Validation
    if (!title || !author) {
      return res.status(400).json({
        success: false,
        message: 'Title and author are required'
      });
    }

    // Check if book already exists (optional - you can remove this if you want duplicates)
    const existingBook = await Book.findOne({
      title: { $regex: new RegExp(`^${title}$`, 'i') },
      author: { $regex: new RegExp(`^${author}$`, 'i') }
    });

    if (existingBook) {
      return res.status(409).json({
        success: false,
        message: 'A book with this title and author already exists'
      });
    }

    const book = new Book({
      title,
      author,
      publishedYear: publishedYear || null,
      image: image || 'assets/libro.jpg'
    });

    const savedBook = await book.save();

    res.status(201).json({
      success: true,
      message: 'Book created successfully',
      data: savedBook
    });
  } catch (error) {
    console.error('Error creating book:', error);
    
    if (error.name === 'ValidationError') {
      return res.status(400).json({
        success: false,
        message: 'Validation error',
        errors: Object.values(error.errors).map(err => err.message)
      });
    }

    res.status(500).json({
      success: false,
      message: 'Failed to create book',
      error: error.message
    });
  }
});

// Update a book
app.put('/api/books/:id', async (req, res) => {
  try {
    const { title, author, publishedYear, image } = req.body;

    // Validation
    if (!title || !author) {
      return res.status(400).json({
        success: false,
        message: 'Title and author are required'
      });
    }

    const updatedBook = await Book.findByIdAndUpdate(
      req.params.id,
      {
        title,
        author,
        publishedYear: publishedYear || null,
        image: image || 'assets/libro.jpg',
        updatedAt: new Date()
      },
      { new: true, runValidators: true }
    );

    if (!updatedBook) {
      return res.status(404).json({
        success: false,
        message: 'Book not found'
      });
    }

    res.json({
      success: true,
      message: 'Book updated successfully',
      data: updatedBook
    });
  } catch (error) {
    console.error('Error updating book:', error);
    
    if (error.name === 'ValidationError') {
      return res.status(400).json({
        success: false,
        message: 'Validation error',
        errors: Object.values(error.errors).map(err => err.message)
      });
    }

    res.status(500).json({
      success: false,
      message: 'Failed to update book',
      error: error.message
    });
  }
});

// Delete a book
app.delete('/api/books/:id', async (req, res) => {
  try {
    const deletedBook = await Book.findByIdAndDelete(req.params.id);

    if (!deletedBook) {
      return res.status(404).json({
        success: false,
        message: 'Book not found'
      });
    }

    res.json({
      success: true,
      message: 'Book deleted successfully',
      data: deletedBook
    });
  } catch (error) {
    console.error('Error deleting book:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to delete book',
      error: error.message
    });
  }
});

// Bulk operations
app.post('/api/books/bulk', async (req, res) => {
  try {
    const { operation, bookIds } = req.body;

    if (!operation || !bookIds || !Array.isArray(bookIds)) {
      return res.status(400).json({
        success: false,
        message: 'Operation and bookIds array are required'
      });
    }

    let result;
    switch (operation) {
      case 'delete':
        result = await Book.deleteMany({ _id: { $in: bookIds } });
        res.json({
          success: true,
          message: `${result.deletedCount} books deleted successfully`,
          deletedCount: result.deletedCount
        });
        break;
      default:
        res.status(400).json({
          success: false,
          message: 'Invalid operation'
        });
    }
  } catch (error) {
    console.error('Error in bulk operation:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to perform bulk operation',
      error: error.message
    });
  }
});

// Search books
app.get('/api/books/search', async (req, res) => {
  try {
    const { q, limit = 10 } = req.query;

    if (!q) {
      return res.status(400).json({
        success: false,
        message: 'Search query is required'
      });
    }

    const books = await Book.find({
      $or: [
        { title: { $regex: q, $options: 'i' } },
        { author: { $regex: q, $options: 'i' } }
      ]
    })
    .limit(parseInt(limit))
    .sort({ createdAt: -1 });

    res.json({
      success: true,
      data: books,
      total: books.length
    });
  } catch (error) {
    console.error('Error searching books:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to search books',
      error: error.message
    });
  }
});

// Get statistics
app.get('/api/stats', async (req, res) => {
  try {
    const totalBooks = await Book.countDocuments();
    const booksThisYear = await Book.countDocuments({
      publishedYear: new Date().getFullYear()
    });
    const booksThisMonth = await Book.countDocuments({
      createdAt: {
        $gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
      }
    });

    // Get top authors
    const topAuthors = await Book.aggregate([
      { $group: { _id: '$author', count: { $sum: 1 } } },
      { $sort: { count: -1 } },
      { $limit: 5 }
    ]);

    res.json({
      success: true,
      data: {
        totalBooks,
        booksThisYear,
        booksThisMonth,
        topAuthors
      }
    });
  } catch (error) {
    console.error('Error fetching stats:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch statistics',
      error: error.message
    });
  }
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Unhandled error:', err);
  res.status(500).json({
    success: false,
    message: 'Internal server error',
    error: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found'
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server is running on port ${PORT}`);
  console.log(`📚 Book Library API: http://localhost:${PORT}`);
  console.log(`🔍 Health check: http://localhost:${PORT}/api/health`);
});

module.exports = app;
