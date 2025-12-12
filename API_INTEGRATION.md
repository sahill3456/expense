# API Integration Guide

This document provides guidelines for integrating a backend API with the Expense Tracker app.

## Current Architecture

The app currently uses:
- **Local Storage**: Hive (NoSQL database)
- **Authentication**: Firebase Auth
- **Offline-First**: All data stored locally

## Why Add a Backend API?

Benefits of integrating a backend:
- **Cross-Device Sync**: Access data from multiple devices
- **Cloud Backup**: Automatic data backup
- **Collaborative Features**: Real-time bill splitting
- **Advanced Analytics**: ML-powered insights
- **Scalability**: Support for large datasets
- **Security**: Centralized data management

## Recommended Architecture

### Hybrid Approach (Recommended)

```
┌─────────────┐
│   Flutter   │
│     App     │
└──────┬──────┘
       │
       ├──────────────┐
       │              │
       ▼              ▼
┌──────────┐   ┌──────────┐
│   Hive   │   │   API    │
│  (Local) │   │ (Remote) │
└──────────┘   └────┬─────┘
                    │
                    ▼
              ┌──────────┐
              │ Database │
              │(Postgres)│
              └──────────┘
```

**Offline-First Strategy**:
1. Write to local Hive database
2. Queue API sync operation
3. Sync when online
4. Handle conflicts

## API Design

### Base URL

```
https://api.expensetracker.com/v1
```

### Authentication

Use Firebase Auth tokens for API authentication:

```http
Authorization: Bearer <firebase_id_token>
```

### API Endpoints

#### Authentication

```http
POST /auth/register
POST /auth/login
POST /auth/refresh
POST /auth/logout
```

#### User Management

```http
GET    /users/me
PUT    /users/me
DELETE /users/me
PATCH  /users/me/settings
```

#### Expenses

```http
GET    /expenses                    # List all expenses
POST   /expenses                    # Create expense
GET    /expenses/:id                # Get expense details
PUT    /expenses/:id                # Update expense
DELETE /expenses/:id                # Delete expense
GET    /expenses/search?q=:query    # Search expenses
GET    /expenses/filter             # Filter expenses
```

#### Categories

```http
GET    /categories                  # List categories
POST   /categories                  # Create custom category
DELETE /categories/:id              # Delete custom category
```

#### Analytics

```http
GET    /analytics/monthly           # Monthly summary
GET    /analytics/weekly            # Weekly summary
GET    /analytics/categories        # Category breakdown
GET    /analytics/trends            # Spending trends
GET    /analytics/insights          # AI insights
```

#### Bill Splitting

```http
GET    /expenses/:id/splits         # Get expense splits
POST   /expenses/:id/splits         # Add participants
PUT    /expenses/:id/splits/:userId # Update split
DELETE /expenses/:id/splits/:userId # Remove participant
POST   /expenses/:id/splits/settle  # Mark as settled
```

#### Sync

```http
POST   /sync                        # Full sync
GET    /sync/changes?since=:timestamp # Incremental sync
```

## Request/Response Examples

### Create Expense

**Request:**
```http
POST /expenses
Content-Type: application/json
Authorization: Bearer <token>

{
  "amount": 25.50,
  "category": "foodDining",
  "description": "Lunch at cafe",
  "date": "2024-12-12T12:30:00Z",
  "isRecurring": false,
  "paymentMethod": "credit_card",
  "tags": ["lunch", "work"]
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "exp_123456",
    "userId": "user_789",
    "amount": 25.50,
    "category": "foodDining",
    "description": "Lunch at cafe",
    "date": "2024-12-12T12:30:00Z",
    "createdAt": "2024-12-12T12:31:00Z",
    "updatedAt": "2024-12-12T12:31:00Z",
    "isRecurring": false,
    "paymentMethod": "credit_card",
    "tags": ["lunch", "work"]
  }
}
```

### Get Monthly Analytics

**Request:**
```http
GET /analytics/monthly?year=2024&month=12
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "year": 2024,
    "month": 12,
    "totalExpenses": 1250.75,
    "expenseCount": 42,
    "averagePerDay": 40.35,
    "categoryBreakdown": [
      {"category": "foodDining", "amount": 450.25, "percentage": 36},
      {"category": "fashion", "amount": 320.50, "percentage": 26},
      {"category": "entertainment", "amount": 280.00, "percentage": 22}
    ],
    "dailyExpenses": [
      {"date": "2024-12-01", "amount": 35.50},
      {"date": "2024-12-02", "amount": 62.30}
    ]
  }
}
```

## Implementation in Flutter

### 1. Create API Service

Create `lib/services/api_service.dart`:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static const String baseUrl = 'https://api.expensetracker.com/v1';
  
  static Future<String> _getAuthToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return await user.getIdToken() ?? '';
  }
  
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  
  // Create expense
  static Future<ExpenseModel> createExpense(ExpenseModel expense) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/expenses'),
      headers: headers,
      body: jsonEncode(expense.toJson()),
    );
    
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body)['data'];
      return ExpenseModel.fromJson(data);
    } else {
      throw Exception('Failed to create expense');
    }
  }
  
  // Get expenses
  static Future<List<ExpenseModel>> getExpenses() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/expenses'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => ExpenseModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load expenses');
    }
  }
  
  // Sync expenses
  static Future<void> syncExpenses(List<ExpenseModel> localExpenses) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/sync'),
      headers: headers,
      body: jsonEncode({
        'expenses': localExpenses.map((e) => e.toJson()).toList(),
      }),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Sync failed');
    }
  }
}
```

### 2. Update Expense Provider

Modify `lib/providers/expense_provider.dart`:

```dart
Future<void> addExpense(ExpenseModel expense) async {
  // 1. Save locally first (offline-first)
  await DatabaseService.addExpense(expense);
  _expenses.add(expense);
  notifyListeners();
  
  // 2. Sync to API in background
  try {
    await ApiService.createExpense(expense);
  } catch (e) {
    // Queue for retry if offline
    _queueForSync(expense);
  }
}

Future<void> syncExpenses() async {
  try {
    // Get all local expenses
    final localExpenses = DatabaseService.getAllExpenses();
    
    // Sync to API
    await ApiService.syncExpenses(localExpenses);
    
    // Get latest from API
    final remoteExpenses = await ApiService.getExpenses();
    
    // Merge and resolve conflicts
    _mergeExpenses(localExpenses, remoteExpenses);
  } catch (e) {
    print('Sync failed: $e');
  }
}
```

### 3. Add Connectivity Check

Add connectivity checking:

```dart
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
  
  static Stream<bool> get onConnectivityChanged {
    return Connectivity().onConnectivityChanged.map(
      (result) => result != ConnectivityResult.none,
    );
  }
}
```

### 4. Implement Sync Queue

Create `lib/services/sync_service.dart`:

```dart
class SyncService {
  static final List<Function> _syncQueue = [];
  
  static void queueSync(Function syncFunction) {
    _syncQueue.add(syncFunction);
  }
  
  static Future<void> processSyncQueue() async {
    if (!await ConnectivityService.isOnline()) return;
    
    for (final syncFunction in _syncQueue) {
      try {
        await syncFunction();
      } catch (e) {
        print('Sync error: $e');
      }
    }
    
    _syncQueue.clear();
  }
}
```

## Error Handling

### HTTP Status Codes

- `200 OK`: Successful GET, PUT, DELETE
- `201 Created`: Successful POST
- `400 Bad Request`: Invalid input
- `401 Unauthorized`: Invalid or expired token
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Resource not found
- `409 Conflict`: Data conflict (sync issue)
- `422 Unprocessable Entity`: Validation error
- `429 Too Many Requests`: Rate limit exceeded
- `500 Internal Server Error`: Server error
- `503 Service Unavailable`: Server down

### Conflict Resolution

When local and remote data conflict:

```dart
ExpenseModel _resolveConflict(
  ExpenseModel local,
  ExpenseModel remote,
) {
  // Use most recently updated version
  if (local.updatedAt!.isAfter(remote.updatedAt!)) {
    return local;
  } else {
    return remote;
  }
}
```

## Rate Limiting

Implement rate limiting to avoid overwhelming the API:

```dart
class RateLimiter {
  static final _timestamps = <String, DateTime>{};
  static const _requestsPerMinute = 60;
  
  static bool canMakeRequest(String endpoint) {
    final key = endpoint;
    final now = DateTime.now();
    
    if (_timestamps.containsKey(key)) {
      final lastRequest = _timestamps[key]!;
      final difference = now.difference(lastRequest);
      
      if (difference.inSeconds < 60 / _requestsPerMinute) {
        return false; // Rate limit exceeded
      }
    }
    
    _timestamps[key] = now;
    return true;
  }
}
```

## Caching Strategy

Implement caching to reduce API calls:

```dart
class CacheService {
  static final _cache = <String, CacheEntry>{};
  
  static T? get<T>(String key) {
    final entry = _cache[key];
    if (entry != null && !entry.isExpired) {
      return entry.data as T;
    }
    return null;
  }
  
  static void set(String key, dynamic data, Duration ttl) {
    _cache[key] = CacheEntry(data, DateTime.now().add(ttl));
  }
}

class CacheEntry {
  final dynamic data;
  final DateTime expiresAt;
  
  CacheEntry(this.data, this.expiresAt);
  
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
```

## Backend Technology Recommendations

### Node.js + Express

```javascript
const express = require('express');
const app = express();

app.post('/expenses', async (req, res) => {
  const expense = await Expense.create(req.body);
  res.status(201).json({ success: true, data: expense });
});
```

### Python + FastAPI

```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

@app.post("/expenses")
async def create_expense(expense: ExpenseModel):
    # Save to database
    return {"success": True, "data": expense}
```

### Go + Gin

```go
package main

import "github.com/gin-gonic/gin"

func main() {
    r := gin.Default()
    r.POST("/expenses", createExpense)
    r.Run(":8080")
}
```

## Database Options

- **PostgreSQL**: Relational, ACID compliance, great for complex queries
- **MongoDB**: NoSQL, flexible schema, good for rapid development
- **Firebase Firestore**: Managed, real-time, easy integration
- **Supabase**: Open-source Firebase alternative with PostgreSQL

## Testing the API

### Using Postman

1. Import API collection
2. Set environment variables (base URL, token)
3. Test each endpoint

### Using curl

```bash
# Get expenses
curl -X GET https://api.expensetracker.com/v1/expenses \
  -H "Authorization: Bearer YOUR_TOKEN"

# Create expense
curl -X POST https://api.expensetracker.com/v1/expenses \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"amount": 25.50, "category": "foodDining"}'
```

## Security Best Practices

- Use HTTPS for all API calls
- Implement rate limiting
- Validate all inputs on the server
- Use Firebase Auth for authentication
- Implement proper authorization (users can only access their own data)
- Sanitize database queries to prevent SQL injection
- Use environment variables for secrets
- Implement CORS properly
- Log security events
- Keep dependencies updated

## Monitoring and Logging

- Use APM tools (New Relic, Datadog)
- Log all API requests and errors
- Monitor response times
- Set up alerts for failures
- Track API usage and costs

## Migration Path

1. **Phase 1**: Add API service (optional sync)
2. **Phase 2**: Implement background sync
3. **Phase 3**: Add conflict resolution
4. **Phase 4**: Make API primary, Hive as cache
5. **Phase 5**: Add advanced features (real-time sync, ML insights)

---

**Questions?** Open an issue or contact the development team.
