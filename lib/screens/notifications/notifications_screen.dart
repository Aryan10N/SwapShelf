import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/firebase_service.dart';
import '../../screens/swap/swap_request_details_screen.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    if (!_isRefreshing) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Sample notifications data
      final sampleNotifications = [
        {
          'id': '1',
          'title': 'New Swap Request',
          'body': 'John wants to swap "Atomic Habits" with your book',
          'type': 'swap_request',
          'read': false,
          'createdAt': DateTime.now().subtract(const Duration(minutes: 5)),
          'data': {'swapRequestId': 'swap123'},
        },
        {
          'id': '2',
          'title': 'Swap Request Accepted',
          'body': 'Sarah accepted your swap request for "Deep Work"',
          'type': 'swap_request_update',
          'read': false,
          'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
          'data': {'swapRequestId': 'swap456'},
        },
        {
          'id': '3',
          'title': 'Book Added Successfully',
          'body': 'Your book "The Psychology of Money" has been added to your shelf',
          'type': 'system',
          'read': true,
          'createdAt': DateTime.now().subtract(const Duration(hours: 5)),
        },
        {
          'id': '4',
          'title': 'New Message',
          'body': 'Mike sent you a message about "Zero to One"',
          'type': 'message',
          'read': true,
          'createdAt': DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          'id': '5',
          'title': 'Swap Completed',
          'body': 'Your swap with Alex has been completed successfully',
          'type': 'swap_request_update',
          'read': true,
          'createdAt': DateTime.now().subtract(const Duration(days: 2)),
          'data': {'swapRequestId': 'swap789'},
        },
      ];

      setState(() {
        _notifications = sampleNotifications;
        _isLoading = false;
        _isRefreshing = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _error = 'Failed to load notifications: $e';
      });
    }
  }

  Future<void> _handleNotificationTap(Map<String, dynamic> notification) async {
    HapticFeedback.lightImpact();
    
    if (notification['read'] == false) {
      setState(() {
        notification['read'] = true;
      });
    }

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

  Future<void> _deleteNotification(String notificationId) async {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification deleted')),
    );
  }

  Future<void> _markAllAsRead() async {
    setState(() {
      for (var notification in _notifications) {
        notification['read'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  Future<void> _clearAllNotifications() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to clear all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _notifications.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All notifications cleared')),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you when something happens',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error occurred',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadNotifications,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final date = notification['createdAt'] as DateTime;
    final formattedDate = DateFormat('MMM d, y').format(date);
    
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
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Delete Notification'),
            content: const Text('Are you sure you want to delete this notification?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (direction) => _deleteNotification(notification['id']),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: notification['read'] ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: notification['read'] ? Colors.grey[200]! : const Color(0xFF6C63FF),
            width: notification['read'] ? 1 : 2,
          ),
        ),
        child: ListTile(
          onTap: () => _handleNotificationTap(notification),
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            backgroundColor: notification['read'] 
                ? Colors.grey[200]
                : const Color(0xFF6C63FF),
            child: Icon(
              _getNotificationIcon(notification['type']),
              color: notification['read'] ? Colors.grey[600] : Colors.white,
            ),
          ),
          title: Text(
            notification['title'],
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: notification['read'] ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification['body'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        actions: [
          if (_notifications.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.done_all, color: Color(0xFF6C63FF)),
              onPressed: _markAllAsRead,
              tooltip: 'Mark all as read',
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Color(0xFF6C63FF)),
              onPressed: _clearAllNotifications,
              tooltip: 'Clear all notifications',
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
            )
          : _error != null
              ? _buildErrorState()
              : _notifications.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: () async {
                        setState(() => _isRefreshing = true);
                        await _loadNotifications();
                      },
                      color: const Color(0xFF6C63FF),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          return _buildNotificationItem(_notifications[index]);
                        },
                      ),
                    ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'swap_request':
        return Icons.swap_horiz;
      case 'swap_request_update':
        return Icons.update;
      case 'message':
        return Icons.message;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }
} 