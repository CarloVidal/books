# Book Library Backend API

A RESTful API backend for the Book Library Flutter application built with Express.js and MongoDB.

## 🚀 Features

- **CRUD Operations**: Create, Read, Update, Delete books
- **Search & Filter**: Search books by title or author
- **Pagination**: Efficient pagination for large datasets
- **Validation**: Input validation and error handling
- **Statistics**: Get library statistics and analytics
- **Bulk Operations**: Delete multiple books at once
- **Health Check**: API health monitoring endpoint

## 📋 Prerequisites

- Node.js (v14 or higher)
- MongoDB (local or Atlas)
- npm or yarn

## 🛠️ Installation

1. **Clone the repository and navigate to the backend folder:**
   ```bash
   cd Backend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Create environment file:**
   ```bash
   # Copy the example file
   cp .env.example .env
   # Or create .env manually with the following content:
   ```

   ```env
   # Server Configuration
   PORT=3000
   NODE_ENV=development

   # MongoDB Configuration
   MONGODB_URI=mongodb://localhost:27017/booklibrary

   # Optional: MongoDB Atlas
   # MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/booklibrary?retryWrites=true&w=majority
   ```

4. **Start MongoDB:**
   - **Local MongoDB**: Make sure MongoDB is running on your machine
   - **MongoDB Atlas**: Use the connection string from your Atlas cluster

5. **Run the server:**
   ```bash
   # Development mode (with auto-reload)
   npm run dev

   # Production mode
   npm start
   ```

## 📚 API Endpoints

### Health Check
- `GET /api/health` - Check API status

### Books
- `GET /api/books` - Get all books (with pagination and search)
- `GET /api/books/:id` - Get a specific book
- `POST /api/books` - Create a new book
- `PUT /api/books/:id` - Update a book
- `DELETE /api/books/:id` - Delete a book

### Search
- `GET /api/books/search?q=query` - Search books by title or author

### Bulk Operations
- `POST /api/books/bulk` - Bulk delete books

### Statistics
- `GET /api/stats` - Get library statistics

## 📖 API Documentation

### Book Object Structure
```json
{
  "_id": "60f7b3b3b3b3b3b3b3b3b3b3",
  "title": "Book Title",
  "author": "Author Name",
  "publishedYear": 2023,
  "image": "assets/libro.jpg",
  "createdAt": "2023-12-01T10:00:00.000Z",
  "updatedAt": "2023-12-01T10:00:00.000Z"
}
```

### Get All Books
```bash
GET /api/books?page=1&limit=10&search=harry&sortBy=title&sortOrder=asc
```

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 50, max: 100)
- `search` (optional): Search term for title or author
- `sortBy` (optional): Sort field (default: createdAt)
- `sortOrder` (optional): asc or desc (default: desc)

**Response:**
```json
{
  "success": true,
  "data": [...],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalBooks": 50,
    "hasNextPage": true,
    "hasPrevPage": false
  }
}
```

### Create Book
```bash
POST /api/books
Content-Type: application/json

{
  "title": "New Book Title",
  "author": "Author Name",
  "publishedYear": 2023,
  "image": "assets/demon1.jpg"
}
```

### Update Book
```bash
PUT /api/books/:id
Content-Type: application/json

{
  "title": "Updated Book Title",
  "author": "Updated Author Name",
  "publishedYear": 2023,
  "image": "assets/demon2.jpg"
}
```

### Search Books
```bash
GET /api/books/search?q=harry&limit=10
```

### Get Statistics
```bash
GET /api/stats
```

**Response:**
```json
{
  "success": true,
  "data": {
    "totalBooks": 150,
    "booksThisYear": 25,
    "booksThisMonth": 5,
    "topAuthors": [
      { "_id": "J.K. Rowling", "count": 10 },
      { "_id": "Stephen King", "count": 8 }
    ]
  }
}
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server port | 3000 |
| `NODE_ENV` | Environment mode | development |
| `MONGODB_URI` | MongoDB connection string | mongodb://localhost:27017/booklibrary |

### MongoDB Setup

**Local MongoDB:**
1. Install MongoDB on your machine
2. Start MongoDB service
3. The database will be created automatically

**MongoDB Atlas:**
1. Create a free account at [MongoDB Atlas](https://www.mongodb.com/atlas)
2. Create a new cluster
3. Get your connection string
4. Replace the MONGODB_URI in your .env file

## 🚀 Deployment

### Heroku
1. Create a Heroku app
2. Add MongoDB Atlas addon
3. Set environment variables
4. Deploy with Git

### Railway
1. Connect your GitHub repository
2. Add MongoDB service
3. Deploy automatically

### Vercel
1. Import your repository
2. Set environment variables
3. Deploy

## 🧪 Testing

Test the API endpoints using tools like:
- [Postman](https://www.postman.com/)
- [Insomnia](https://insomnia.rest/)
- [cURL](https://curl.se/)

### Example cURL commands:

```bash
# Health check
curl http://localhost:3000/api/health

# Get all books
curl http://localhost:3000/api/books

# Create a book
curl -X POST http://localhost:3000/api/books \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Book","author":"Test Author","publishedYear":2023}'

# Search books
curl "http://localhost:3000/api/books/search?q=test"
```

## 📝 Error Handling

The API returns consistent error responses:

```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error message (development only)"
}
```

Common HTTP status codes:
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `404` - Not Found
- `409` - Conflict (duplicate book)
- `500` - Internal Server Error

## 🔒 Security

- CORS enabled for cross-origin requests
- Input validation and sanitization
- Error messages don't expose sensitive information in production
- MongoDB injection protection through Mongoose

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the ISC License.

## 🆘 Support

If you encounter any issues:
1. Check the console logs for error messages
2. Verify MongoDB connection
3. Ensure all environment variables are set correctly
4. Check that the port is not already in use

## 🔗 Links

- [Express.js Documentation](https://expressjs.com/)
- [Mongoose Documentation](https://mongoosejs.com/)
- [MongoDB Documentation](https://docs.mongodb.com/) 