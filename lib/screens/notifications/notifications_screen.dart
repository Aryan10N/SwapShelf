import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/firebase_service.dart';
import '../../screens/swap/swap_request_details_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final userId = context.read<AuthProvider>().user?.uid;
    if (userId == null) return;

    try {
      final notifications = await _firebaseService.getNotifications(userId);
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load notifications: $e')),
      );
    }
  }

  Future<void> _handleNotificationTap(Map<String, dynamic> notification) async {
    if (notification['read'] == false) {
      await _firebaseService.markNotificationAsRead(notification['id']);
      setState(() {
        notification['read'] = true;
      });
    }

    // Handle different notification types
    switch (notification['type']) {
      case 'swap_request':
      case 'swap_request_update':
        if (notification['data'] != null &&
            notification['data']['swapRequestId'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SwapRequestDetailsScreen(
                swapRequestId: notification['data']['swapRequestId'],
              ),
            ),
          );
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(
                  child: Text(
                    'No notifications yet',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return Dismissible(
                      key: Key(notification['id']),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        // TODO: Implement delete notification
                        setState(() {
                          _notifications.removeAt(index);
                        });
                      },
                      child: ListTile(
                        onTap: () => _handleNotificationTap(notification),
                        leading: CircleAvatar(
                          backgroundColor: notification['read'] == false
                              ? const Color(0xFF6C63FF)
                              : Colors.grey,
                          child: Icon(
                            _getNotificationIcon(notification['type']),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          notification['title'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: notification['read'] == false
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          notification['body'],
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Text(
                          _formatDate(notification['createdAt']),
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'swap_request':
        return Icons.swap_horiz;
      case 'swap_request_update':
        return Icons.update;
      default:
        return Icons.notifications;
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
} 