const mongoose = require('mongoose');
const dotenv = require('dotenv');

// Load environment variables
dotenv.config();

// Sample books data
const sampleBooks = [
  {
    title: 'Kuko Ng Agila',
    author: 'Harper Lee',
    publishedYear: 1960,
    image: 'assets/demon1.jpg'
  },
  {
    title: 'Deathly Hallows',
    author: 'George Orwell',
    publishedYear: 1949,
    image: 'assets/demon2.jpg'
  },
  {
    title: 'Order of the Phoenix',
    author: 'F. Scott Fitzgerald',
    publishedYear: 1925,
    image: 'assets/demon3.jpg'
  },
  {
    title: 'The Sorcerers Stone',
    author: 'Jane Austen',
    publishedYear: 1813,
    image: 'assets/demon4.jpg'
  },
  {
    title: 'The Great Gatsby',
    author: 'F. Scott Fitzgerald',
    publishedYear: 1925,
    image: 'assets/demon5.jpg'
  },
  {
    title: 'Pride and Prejudice',
    author: 'Jane Austen',
    publishedYear: 1813,
    image: 'assets/demon6.jpg'
  }
];

// Book Schema (same as in server.js)
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

const Book = mongoose.model('Book', bookSchema);

async function setupDatabase() {
  console.log('🚀 Setting up Book Library Database...\n');

  try {
    // Connect to MongoDB
    console.log('📡 Connecting to MongoDB...');
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/booklibrary', {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('✅ Connected to MongoDB successfully!\n');

    // Check if books already exist
    const existingBooks = await Book.countDocuments();
    
    if (existingBooks > 0) {
      console.log(`📚 Database already contains ${existingBooks} books.`);
      console.log('💡 Skipping sample data insertion.\n');
    } else {
      console.log('📖 Inserting sample books...');
      
      // Insert sample books
      const insertedBooks = await Book.insertMany(sampleBooks);
      console.log(`✅ Successfully inserted ${insertedBooks.length} sample books!\n`);
      
      console.log('📋 Sample books added:');
      insertedBooks.forEach((book, index) => {
        console.log(`   ${index + 1}. "${book.title}" by ${book.author} (${book.publishedYear})`);
      });
      console.log('');
    }

    // Get database statistics
    const totalBooks = await Book.countDocuments();
    const booksThisYear = await Book.countDocuments({
      publishedYear: new Date().getFullYear()
    });

    console.log('📊 Database Statistics:');
    console.log(`   Total Books: ${totalBooks}`);
    console.log(`   Books Published This Year: ${booksThisYear}`);
    console.log('');

    console.log('🎉 Database setup completed successfully!');
    console.log('🚀 You can now start the server with: npm run dev');
    console.log('🔍 Test the API with: node test-api.js');

  } catch (error) {
    console.error('❌ Setup failed:', error.message);
    console.log('');
    console.log('💡 Troubleshooting tips:');
    console.log('   1. Make sure MongoDB is running');
    console.log('   2. Check your MONGODB_URI in .env file');
    console.log('   3. Ensure the database name is correct');
    console.log('   4. Try running: mongod (to start MongoDB)');
  } finally {
    // Close the connection
    await mongoose.connection.close();
    console.log('🔌 Database connection closed.');
  }
}

// Run setup
setupDatabase(); 