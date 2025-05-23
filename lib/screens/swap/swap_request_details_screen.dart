import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/swap_request_model.dart';
import '../../models/book_model.dart';
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
      final swapRequest = await _firebaseService.getSwapRequest(widget.swapRequestId);
      if (swapRequest != null) {
        setState(() {
          _swapRequest = swapRequest;
        });
        await _loadBooks();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load swap request: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadBooks() async {
    if (_swapRequest == null) return;

    try {
      final requestedBook = await _firebaseService.getBook(_swapRequest!.bookId);
      final requesterBook = _swapRequest!.requesterBookId != null
          ? await _firebaseService.getBook(_swapRequest!.requesterBookId!)
          : null;

      setState(() {
        _requestedBook = requestedBook;
        _requesterBook = requesterBook;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load books: $e')),
      );
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
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        title: const Text(
          'Swap Request Details',
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
          : _swapRequest == null
              ? const Center(
                  child: Text(
                    'Swap request not found',
                    style: TextStyle(color: Colors.white70),
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