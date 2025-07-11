# 📚 Book Library App - Full Stack Project

A complete book library management system with a **Node.js/Express backend API** and a **Flutter mobile application**. This project demonstrates full-stack development with real-time data synchronization between backend and mobile app.

## 🏗️ Project Structure

```
books/
├── Backend/                 # Node.js/Express API Server
│   ├── server.js           # Main server file
│   ├── package.json        # Dependencies
│   ├── setup.js           # Database setup script
│   ├── test-api.js        # API testing script
│   ├── README.md          # Backend documentation
│   └── .gitignore         # Git ignore file
│
└── flutter_application_1/  # Flutter Mobile App
    ├── lib/
    │   ├── main.dart      # App entry point
    │   ├── home.dart      # Main screen
    │   ├── add_book_page.dart  # Add/Edit book screen
    │   ├── models/
    │   │   └── book.dart  # Book data model
    │   └── services/
    │       ├── api_service.dart    # API communication
    │       └── book_repository.dart # Data management
    ├── assets/            # Images and resources
    └── pubspec.yaml       # Flutter dependencies
```

## 🚀 Features

### Backend API Features
- ✅ **RESTful API** with Express.js and MongoDB
- ✅ **CRUD Operations** - Create, Read, Update, Delete books
- ✅ **Search & Filtering** - Search books by title or author
- ✅ **Pagination** - Efficient data pagination
- ✅ **Input Validation** - Request validation and error handling
- ✅ **Statistics API** - Library analytics and metrics
- ✅ **Bulk Operations** - Delete multiple books
- ✅ **Health Check** - API health monitoring
- ✅ **CORS Support** - Cross-origin resource sharing

### Mobile App Features
- ✅ **Real-time Sync** - Live data from backend API
- ✅ **Add Books** - Create new books with image selection
- ✅ **Delete Books** - Remove books with confirmation
- ✅ **Error Handling** - Network and API error management
- ✅ **Loading States** - Smooth loading animations
- ✅ **Offline Detection** - Network connectivity monitoring
- ✅ **Image Selection** - Choose from available book covers
- ✅ **Responsive UI** - Beautiful Material Design interface

## 🛠️ Technology Stack

### Backend
- **Node.js** - JavaScript runtime
- **Express.js** - Web framework
- **MongoDB** - NoSQL database
- **Mongoose** - MongoDB object modeling
- **CORS** - Cross-origin resource sharing
- **dotenv** - Environment variables

### Frontend (Mobile App)
- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **HTTP** - API communication
- **Connectivity Plus** - Network status monitoring
- **Shared Preferences** - Local storage (legacy)

## 📋 Prerequisites

### System Requirements
- **Node.js** (v14 or higher)
- **MongoDB** (local or Atlas)
- **Flutter SDK** (v3.8.1 or higher)
- **Android Studio** / **VS Code**
- **Git**

### Network Requirements
- **Backend Server IP**: `192.168.195.173`
- **Backend Port**: `3000`
- **API Base URL**: `http://192.168.195.173:3000/api`

## 🚀 Installation & Setup

### 1. Backend Setup

```bash
# Navigate to backend directory
cd Backend

# Install dependencies
npm install

# Create environment file (optional)
# Copy .env.example to .env and configure

# Start the server
npm run dev
# or
npm start
```

**Backend will be available at:** `http://192.168.195.173:3000`

### 2. Mobile App Setup

```bash
# Navigate to Flutter app directory
cd flutter_application_1

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📱 API Endpoints

### Base URL: `http://192.168.195.173:3000/api`

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/health` | API health check |
| `GET` | `/books` | Get all books |
| `POST` | `/books` | Create new book |
| `GET` | `/books/:id` | Get book by ID |
| `PUT` | `/books/:id` | Update book |
| `DELETE` | `/books/:id` | Delete book |
| `GET` | `/books/search?q=query` | Search books |
| `GET` | `/books/stats` | Get library statistics |
| `DELETE` | `/books/bulk` | Delete multiple books |

### Request/Response Examples

#### Create Book
```json
POST /api/books
{
  "title": "The Great Gatsby",
  "author": "F. Scott Fitzgerald",
  "publishedYear": 1925,
  "image": "assets/demon1.jpg"
}
```

#### Get All Books
```json
GET /api/books
Response:
{
  "success": true,
  "data": [
    {
      "_id": "64f8a1b2c3d4e5f6a7b8c9d0",
      "title": "The Great Gatsby",
      "author": "F. Scott Fitzgerald",
      "publishedYear": 1925,
      "image": "assets/demon1.jpg",
      "createdAt": "2024-01-15T10:30:00.000Z",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    }
  ]
}
```

## 📊 Database Schema

### Book Collection
```javascript
{
  _id: ObjectId,
  title: String (required),
  author: String (required),
  publishedYear: Number (optional),
  image: String (default: 'assets/libro.jpg'),
  createdAt: Date,
  updatedAt: Date
}
```

## 🎨 Mobile App Screens

### 1. Home Screen (`home.dart`)
- **Book List** - Display all books from backend
- **Add Button** - Floating action button to add new books
- **Delete Function** - Swipe or tap to delete books
- **Refresh** - Pull to refresh or tap refresh button
- **Error Handling** - Network error display and retry

### 2. Add Book Screen (`add_book_page.dart`)
- **Form Fields** - Title, author, published year
- **Image Selection** - Choose from available book covers
- **Validation** - Input validation and error messages
- **Save Function** - Create or update books

## 🔧 Configuration

### Backend Configuration
```javascript
// server.js
const PORT = process.env.PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/booklibrary';
```

### Mobile App Configuration
```dart
// lib/services/api_service.dart
static const String baseUrl = 'http://192.168.195.173:3000/api';
```

## 🧪 Testing

### Backend Testing
```bash
cd Backend
npm test
# or
node test-api.js
```

### Mobile App Testing
```bash
cd flutter_application_1
flutter test
```

## 📝 Available Scripts

### Backend Scripts
```bash
npm start          # Start production server
npm run dev        # Start development server with nodemon
npm run setup      # Initialize database with sample data
npm test           # Run API tests
```

### Flutter Scripts
```bash
flutter pub get    # Install dependencies
flutter run        # Run the app
flutter build apk  # Build Android APK
flutter build ios  # Build iOS app
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Backend Connection Issues
- **Problem**: Cannot connect to backend
- **Solution**: Check if backend server is running on port 3000
- **Command**: `npm run dev` in Backend directory

#### 2. MongoDB Connection Issues
- **Problem**: Database connection failed
- **Solution**: Ensure MongoDB is running locally or Atlas connection is correct
- **Check**: MongoDB service status

#### 3. Mobile App Network Issues
- **Problem**: App cannot reach backend
- **Solution**: Verify IP address `192.168.195.173` is correct
- **Check**: Network connectivity and firewall settings

#### 4. Flutter Dependencies Issues
- **Problem**: Package resolution errors
- **Solution**: Run `flutter clean` then `flutter pub get`
- **Command**: `flutter pub outdated` to check for updates

## 🔒 Security Considerations

### Backend Security
- ✅ **Input Validation** - All inputs are validated
- ✅ **Error Handling** - Proper error responses
- ✅ **CORS Configuration** - Cross-origin requests allowed
- ⚠️ **Authentication** - Not implemented (can be added)
- ⚠️ **Rate Limiting** - Not implemented (can be added)

### Mobile App Security
- ✅ **HTTPS** - Use HTTPS in production
- ✅ **Input Validation** - Client-side validation
- ✅ **Error Handling** - Graceful error display
- ⚠️ **API Key Storage** - Not implemented (can be added)

## 🚀 Deployment

### Backend Deployment
1. **Environment Setup**
   ```bash
   # Set production environment variables
   export NODE_ENV=production
   export MONGODB_URI=your_mongodb_atlas_uri
   ```

2. **Start Production Server**
   ```bash
   npm start
   ```

### Mobile App Deployment
1. **Build APK**
   ```bash
   flutter build apk --release
   ```

2. **Build iOS**
   ```bash
   flutter build ios --release
   ```

## 📈 Future Enhancements

### Backend Enhancements
- [ ] **Authentication** - JWT token-based auth
- [ ] **User Management** - User registration and login
- [ ] **File Upload** - Image upload functionality
- [ ] **Caching** - Redis caching for performance
- [ ] **Logging** - Comprehensive logging system
- [ ] **Rate Limiting** - API rate limiting
- [ ] **Swagger Documentation** - API documentation

### Mobile App Enhancements
- [ ] **Offline Mode** - Local storage for offline use
- [ ] **Push Notifications** - Real-time notifications
- [ ] **Book Details** - Detailed book information screen
- [ ] **Favorites** - Bookmark favorite books
- [ ] **Categories** - Book categorization
- [ ] **Search** - Advanced search functionality
- [ ] **Dark Mode** - Theme customization

## 👥 Contributing

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Support

If you encounter any issues or have questions:

1. **Check the troubleshooting section** above
2. **Review the API documentation** in Backend/README.md
3. **Check Flutter documentation** for mobile app issues
4. **Create an issue** in the repository

## 🎯 Project Goals

- ✅ **Full-stack Development** - Complete backend and frontend
- ✅ **Real-time Data** - Live synchronization between app and backend
- ✅ **User Experience** - Intuitive and responsive UI
- ✅ **Error Handling** - Robust error management
- ✅ **Scalability** - Modular and extensible architecture
- ✅ **Documentation** - Comprehensive project documentation
