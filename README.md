# 📚 SwapShelf – A College Book-Sharing App


SwapShelf is a peer-to-peer book-sharing mobile app designed specifically for college students.
The app allows students to list physical books they own and are willing to lend, while others can
browse and request to borrow these books instead of buying new ones. Each user has a profile
with ratings, so both borrowers and lenders can build trust through honest feedback. The app
streamlines this process with features like login/signup, book listing, browsing, borrowing
requests, request management, and a review system—all built using Flutter and Dart with Firebase
handling authentication, database, and cloud messaging. By making textbooks and other reading
materials more accessible and affordable, this app promotes resource-sharing and collaboration
among students within the college campus. It's not just a convenience tool—it’s a step toward
building a helpful, sustainable student community.


---

## 🚀 Features

- 🔐 **Secure Authentication** using Firebase Auth (email/password)
- 📸 **List Books** with title, author, description, and image upload
- 🔍 **Browse & Search** books by title, author, or subject
- 🤝 **Request to Borrow** books from peers
- 📥 **Manage Requests** (Accept / Reject)
- ⭐ **Rate Peers** after book return
- 🔔 **Push Notifications** via Firebase Cloud Messaging
- 🧭 **Intuitive Navigation** with a Bottom Nav Bar
- 💬 **Clean UI**, responsive on Android and iOS

---

## 🛠️ Tech Stack
  
| Layer                | Technology                              |
|----------------------|-----------------------------------------|
| **Frontend**         | Flutter + Dart                          |
| **Backend**          | Firebase (Firestore, Auth, Storage)     |
| **Notifications**    | Firebase Cloud Messaging                |
| **State Management** | Provider                                |
| **Image Upload**     | Firebase Storage + Image Picker         |

---

## 📱 Screens & Navigation

### Authentication
- `LoginScreen`
- `RegisterScreen`

### Home (Bottom Navigation)
- **BrowseBooksScreen** – View and search all available books
- **MyListingsScreen** – View, update, or delete your listed books
- **MyRequestsScreen** – Track borrow requests
- **ProfileScreen** – User details, logout, ratings

### Other Screens
- `ListBookScreen` – Add new books
- `BookDetailScreen` – Detailed view + "Request to Borrow" button
- `ViewRequestsScreen` – Book owner's view of incoming requests
- `RatingScreen` – Leave rating after transaction

---

## 🔐 Firebase Collections

### `/users/{userId}`
```json
{
  "name": "John Doe",
  "email": "john@college.edu",
  "profileImage": "url",
  "rating": 4.5
}
```

### `/books/{bookId}`
```json
{
  "title": "Introduction to AI",
  "author": "Stuart Russell",
  "description": "A textbook on AI fundamentals",
  "imageUrl": "url",
  "ownerId": "userId",
  "available": true
}
```

### `/requests/{requestId}`
```json
{
  "bookId": "xyz123",
  "requesterId": "user123",
  "ownerId": "user456",
  "status": "pending",
  "timestamp": "ISODate"
}
```

### `/ratings/{ratingId}`
```json
{
  "from": "user123",
  "to": "user456",
  "bookId": "xyz123",
  "stars": 4,
  "comment": "Very responsive and kind!"
}
```

---

## 📦 Required Packages

```yaml
firebase_core
firebase_auth
cloud_firestore
firebase_storage
firebase_messaging
provider
image_picker
flutter_rating_bar
cached_network_image
```

---

## 🗂️ Folder Structure

```
lib/
 ┣ models/
 ┣ providers/
 ┣ screens/
 ┃ ┣ auth/
 ┃ ┣ home/
 ┃ ┣ book/
 ┃ ┗ profile/
 ┣ services/
 ┣ widgets/
 ┗ main.dart
```

---

## 🧪 Setup Instructions

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/swapshelf.git
   cd swapshelf
   ```

2. Install packages:
   ```bash
   flutter pub get
   ```

3. Set up Firebase:
   - Create a project at [Firebase Console](https://console.firebase.google.com)
   - Add Android/iOS app
   - Download `google-services.json` and `GoogleService-Info.plist` and add them to your project
   - Enable Firestore, Authentication, Cloud Messaging, and Storage

4. Run the app:
   ```bash
   flutter run
   ```

---

## 🔐 Firebase Security Rules (Sample)

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }

    match /books/{bookId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == request.resource.data.ownerId;
    }

    match /requests/{requestId} {
      allow read, write: if request.auth != null;
    }

    match /ratings/{ratingId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == request.resource.data.from;
    }
  }
}
```

---

## 💡 Future Enhancements

- 📊 Smart search with filters
- 🏅 Reward system for frequent lenders
- 📅 Return reminder notifications
- 🌐 Multi-campus support

---

## 🙌 Contribution

Pull requests are welcome. For major changes, open an issue first to discuss what you'd like to change.

---

## 🧑‍💻 Author

- [Aryan Kumar](https://github.com/Aryan10N)
- Flutter App Developer & College Student
- **Utkarsh Aditya** – Developer
- **Vaigainathan** – Developer

---

## 📜 License

This project is licensed under the MIT License.

---

## 📷 Screenshots (Optional)

> Add screenshots or demo video links here once the app is built.

---