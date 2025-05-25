import 'package:flutter/material.dart';
import '../../models/swap_request_model.dart';
import '../../models/book.dart';

class SwapRequestsList extends StatelessWidget {
  const SwapRequestsList({Key? key}) : super(key: key);

  List<Map<String, dynamic>> get _sampleSwapRequests => [
        {
          'swapRequest': SwapRequest(
            id: 'swap_1',
            bookId: 'book_1',
            requesterId: 'user_1',
            ownerId: 'current_user',
            requesterBookId: 'book_2',
            status: SwapRequestStatus.pending,
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
            message: 'I would love to swap my book for yours!',
          ),
          'requestedBook': Book(
            id: 'book_1',
            title: 'The Psychology of Money',
            author: 'Morgan Housel',
            description: 'Timeless lessons on wealth, greed, and happiness.',
            imageUrl: 'https://m.media-amazon.com/images/I/71OUKAvEkaL._AC_UF1000,1000_QL80_.jpg',
            color: Colors.blueAccent,
            available: true,
          ),
          'requesterBook': Book(
            id: 'book_2',
            title: 'Atomic Habits',
            author: 'James Clear',
            description: 'An Easy & Proven Way to Build Good Habits & Break Bad Ones.',
            imageUrl: 'https://m.media-amazon.com/images/I/81bGKUa1e0L._AC_UF1000,1000_QL80_.jpg',
            color: Colors.orangeAccent,
            available: true,
          ),
        },
        {
          'swapRequest': SwapRequest(
            id: 'swap_2',
            bookId: 'book_3',
            requesterId: 'user_2',
            ownerId: 'current_user',
            requesterBookId: 'book_4',
            status: SwapRequestStatus.accepted,
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
            message: 'This book looks interesting! Would you like to swap?',
          ),
          'requestedBook': Book(
            id: 'book_3',
            title: 'Deep Work',
            author: 'Cal Newport',
            description: 'Rules for Focused Success in a Distracted World.',
            imageUrl: 'https://m.media-amazon.com/images/I/71QKQ9mwV7L._AC_UF1000,1000_QL80_.jpg',
            color: Colors.purpleAccent,
            available: true,
          ),
          'requesterBook': Book(
            id: 'book_4',
            title: 'Zero to One',
            author: 'Peter Thiel',
            description: 'Notes on Startups, or How to Build the Future.',
            imageUrl: 'https://m.media-amazon.com/images/I/71m-lAf6abL._AC_UF1000,1000_QL80_.jpg',
            color: Colors.tealAccent,
            available: true,
          ),
        },
        {
          'swapRequest': SwapRequest(
            id: 'swap_3',
            bookId: 'book_5',
            requesterId: 'user_3',
            ownerId: 'current_user',
            requesterBookId: 'book_6',
            status: SwapRequestStatus.rejected,
            createdAt: DateTime.now().subtract(const Duration(days: 7)),
            message: 'I have this book that might interest you!',
          ),
          'requestedBook': Book(
            id: 'book_5',
            title: 'The Subtle Art of Not Giving a F*ck',
            author: 'Mark Manson',
            description: 'A Counterintuitive Approach to Living a Good Life.',
            imageUrl: 'https://m.media-amazon.com/images/I/71QKQ9mwV7L._AC_UF1000,1000_QL80_.jpg',
            color: Colors.redAccent,
            available: true,
          ),
          'requesterBook': Book(
            id: 'book_6',
            title: 'Educated',
            author: 'Tara Westover',
            description: 'A Memoir by Tara Westover.',
            imageUrl: 'https://m.media-amazon.com/images/I/81NwOj14S6L._AC_UF1000,1000_QL80_.jpg',
            color: Colors.amberAccent,
            available: true,
          ),
        },
      ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sampleSwapRequests.length,
      itemBuilder: (context, index) {
        final swapData = _sampleSwapRequests[index];
        final swapRequest = swapData['swapRequest'] as SwapRequest;
        final requestedBook = swapData['requestedBook'] as Book;
        final requesterBook = swapData['requesterBook'] as Book;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/swap_request_details',
                arguments: swapRequest.id,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          requestedBook.imageUrl,
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 120,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.book,
                                color: Colors.grey,
                                size: 40,
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
                              requestedBook.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              requestedBook.author,
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(swapRequest.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                swapRequest.status.toString().split('.').last,
                                style: TextStyle(
                                  color: _getStatusColor(swapRequest.status),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.swap_horiz,
                        color: Color(0xFF6C63FF),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Swap with ${requesterBook.title}',
                        style: const TextStyle(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Requested on ${_formatDate(swapRequest.createdAt)}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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