const axios = require('axios');

const BASE_URL = 'http://localhost:3000/api';

// Test data
const testBook = {
  title: 'Test Book',
  author: 'Test Author',
  publishedYear: 2023,
  image: 'assets/libro.jpg'
};

let createdBookId = null;

async function testAPI() {
  console.log('🧪 Testing Book Library API...\n');

  try {
    // Test 1: Health Check
    console.log('1. Testing Health Check...');
    const healthResponse = await axios.get(`${BASE_URL}/health`);
    console.log('✅ Health Check:', healthResponse.data);
    console.log('');

    // Test 2: Create a book
    console.log('2. Testing Create Book...');
    const createResponse = await axios.post(`${BASE_URL}/books`, testBook);
    console.log('✅ Book Created:', createResponse.data);
    createdBookId = createResponse.data.data._id;
    console.log('');

    // Test 3: Get all books
    console.log('3. Testing Get All Books...');
    const getAllResponse = await axios.get(`${BASE_URL}/books`);
    console.log('✅ Books Retrieved:', getAllResponse.data.data.length, 'books');
    console.log('');

    // Test 4: Get single book
    console.log('4. Testing Get Single Book...');
    const getSingleResponse = await axios.get(`${BASE_URL}/books/${createdBookId}`);
    console.log('✅ Single Book Retrieved:', getSingleResponse.data.data.title);
    console.log('');

    // Test 5: Update book
    console.log('5. Testing Update Book...');
    const updateData = { ...testBook, title: 'Updated Test Book' };
    const updateResponse = await axios.put(`${BASE_URL}/books/${createdBookId}`, updateData);
    console.log('✅ Book Updated:', updateResponse.data.data.title);
    console.log('');

    // Test 6: Search books
    console.log('6. Testing Search Books...');
    const searchResponse = await axios.get(`${BASE_URL}/books/search?q=test`);
    console.log('✅ Search Results:', searchResponse.data.data.length, 'books found');
    console.log('');

    // Test 7: Get statistics
    console.log('7. Testing Get Statistics...');
    const statsResponse = await axios.get(`${BASE_URL}/stats`);
    console.log('✅ Statistics:', statsResponse.data.data);
    console.log('');

    // Test 8: Delete book
    console.log('8. Testing Delete Book...');
    const deleteResponse = await axios.delete(`${BASE_URL}/books/${createdBookId}`);
    console.log('✅ Book Deleted:', deleteResponse.data.message);
    console.log('');

    console.log('🎉 All tests passed successfully!');
    console.log('🚀 Your API is working correctly.');

  } catch (error) {
    console.error('❌ Test failed:', error.response?.data || error.message);
    console.log('');
    console.log('💡 Make sure:');
    console.log('   1. The server is running (npm run dev)');
    console.log('   2. MongoDB is connected');
    console.log('   3. The port 3000 is available');
  }
}

// Run tests
testAPI(); 