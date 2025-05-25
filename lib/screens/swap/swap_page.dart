import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/swap_request_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firebase_service.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({Key? key}) : super(key: key);

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<SwapRequest> _swapRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSwapRequests();
  }

  Future<void> _loadSwapRequests() async {
    try {
      final currentUserId = context.read<AuthProvider>().user?.uid;
      if (currentUserId == null) return;

      final swapRequests = await _firebaseService.getUserSwapRequests(currentUserId);
      setState(() {
        _swapRequests = swapRequests;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load swap requests: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Swap Requests',
          style: TextStyle(
            color: Color(0xFF6C63FF),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadSwapRequests,
              color: const Color(0xFF6C63FF),
              child: _swapRequests.isEmpty
                  ? const Center(
                      child: Text(
                        'No swap requests yet',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _swapRequests.length,
                      itemBuilder: (context, index) {
                        final request = _swapRequests[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              'Swap Request #${request.id.substring(0, 8)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  'Status: ${request.status.toString().split('.').last}',
                                  style: TextStyle(
                                    color: _getStatusColor(request.status),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Requested on: ${_formatDate(request.createdAt)}',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFF6C63FF),
                              size: 16,
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/swap_request_details',
                                arguments: request.id,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  Color _getStatusColor(SwapRequestStatus status) {
    switch (status) {
      case SwapRequestStatus.pending:
        return Colors.orange;
      case SwapRequestStatus.accepted:
        return Colors.green;
      case SwapRequestStatus.rejected:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 