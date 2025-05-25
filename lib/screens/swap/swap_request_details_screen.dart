import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/swap_request_model.dart';
import '../../models/book.dart';
import '../../providers/auth_provider.dart';
import '../../providers/book_provider.dart';
import '../../services/firebase_service.dart';

class SwapRequestDetailsScreen extends StatefulWidget {
  final String swapRequestId;

  const SwapRequestDetailsScreen({
    Key? key,
    required this.swapRequestId,
  }) : super(key: key);

  @override
  State<SwapRequestDetailsScreen> createState() => _SwapRequestDetailsScreenState();
}

class _SwapRequestDetailsScreenState extends State<SwapRequestDetailsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  SwapRequest? _swapRequest;
  Book? _requestedBook;
  Book? _requesterBook;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSwapRequest();
  }

  Future<void> _loadSwapRequest() async {
    try {
      // Sample data for demonstration
      final sampleSwapRequest = SwapRequest(
        id: widget.swapRequestId,
        bookId: 'sample_book_1',
        requesterId: 'sample_user_1',
        ownerId: 'current_user',
        requesterBookId: 'sample_book_2',
        status: SwapRequestStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        message: 'I would love to swap my book for yours!',
      );

      final sampleRequestedBook = Book(
        id: 'sample_book_1',
        title: 'The Psychology of Money',
        author: 'Morgan Housel',
        description: 'Timeless lessons on wealth, greed, and happiness.',
        imageUrl: 'https://m.media-amazon.com/images/I/71OUKAvEkaL._AC_UF1000,1000_QL80_.jpg',
        color: Colors.blueAccent,
        available: true,
      );

      final sampleRequesterBook = Book(
        id: 'sample_book_2',
        title: 'Atomic Habits',
        author: 'James Clear',
        description: 'An Easy & Proven Way to Build Good Habits & Break Bad Ones.',
        imageUrl: 'https://m.media-amazon.com/images/I/81bGKUa1e0L._AC_UF1000,1000_QL80_.jpg',
        color: Colors.orangeAccent,
        available: true,
      );

      setState(() {
        _swapRequest = sampleSwapRequest;
        _requestedBook = sampleRequestedBook;
        _requesterBook = sampleRequesterBook;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load swap request: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSwapRequest(SwapRequestStatus status) async {
    if (_swapRequest == null) return;

    try {
      await _firebaseService.updateSwapRequestStatus(
        _swapRequest!.id,
        status,
      );
      await _loadSwapRequest();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == SwapRequestStatus.accepted
                ? 'Swap request accepted'
                : 'Swap request rejected',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update swap request: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthProvider>().user?.uid;
    final isOwner = currentUserId == _swapRequest?.ownerId;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Swap Request Details',
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
          : _swapRequest == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.swap_horiz,
                        size: 64,
                        color: Color(0xFF6C63FF),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Swap Request Found',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'The swap request you\'re looking for doesn\'t exist or has been removed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusCard(),
                      const SizedBox(height: 16),
                      if (_requestedBook != null) ...[
                        _buildBookCard(
                          'Requested Book',
                          _requestedBook!,
                          isOwner: isOwner,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (_requesterBook != null) ...[
                        _buildBookCard(
                          'Offered Book',
                          _requesterBook!,
                          isOwner: !isOwner,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (_swapRequest!.status == SwapRequestStatus.pending &&
                          isOwner)
                        _buildActionButtons(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      color: const Color(0xFF1F222A),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: ${_swapRequest!.status.toString().split('.').last}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Requested on: ${_formatDate(_swapRequest!.createdAt)}',
              style: const TextStyle(color: Colors.white70),
            ),
            if (_swapRequest!.message != null) ...[
              const SizedBox(height: 8),
              Text(
                'Message: ${_swapRequest!.message}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(String title, Book book, {required bool isOwner}) {
    return Card(
      color: const Color(0xFF1F222A),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    book.imageUrl,
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 150,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.book,
                          color: Colors.white54,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.author,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Owner: ${isOwner ? 'You' : 'Other user'}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _handleSwapRequest(SwapRequestStatus.accepted),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
          ),
          child: const Text('Accept'),
        ),
        ElevatedButton(
          onPressed: () => _handleSwapRequest(SwapRequestStatus.rejected),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
          ),
          child: const Text('Reject'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 