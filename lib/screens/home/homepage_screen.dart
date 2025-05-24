import 'package:flutter/material.dart';
import 'package:swap_shelf/models/book.dart';
import 'package:swap_shelf/widgets/book_item.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _searchController.addListener(_filterBooks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBooks() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredBooks = _books;
      });
    } else {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredBooks = _books.where((book) {
          return book.title.toLowerCase().contains(query) ||
              book.author.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final dummyBooks = [
      Book(
        id: '1',
        title: 'The Psychology of Money',
        author: 'Morgan Housel',
        description: 'Timeless lessons on wealth, greed, and happiness.',
        imageUrl: 'https://m.media-amazon.com/images/I/71OUKAvEkaL._AC_UF1000,1000_QL80_.jpg',
        color: Colors.blueAccent,
        available: true,
      ),
      Book(
        id: '2',
        title: 'Atomic Habits',
        author: 'James Clear',
        description: 'An Easy & Proven Way to Build Good Habits & Break Bad Ones.',
        imageUrl: 'https://m.media-amazon.com/images/I/81bGKUa1e0L._AC_UF1000,1000_QL80_.jpg',
        color: Colors.orangeAccent,
        available: true,
      ),
      Book(
        id: '3',
        title: 'Deep Work',
        author: 'Cal Newport',
        description: 'Rules for Focused Success in a Distracted World.',
        imageUrl: 'https://m.media-amazon.com/images/I/71QKQ9mwV7L._AC_UF1000,1000_QL80_.jpg',
        color: Colors.purpleAccent,
        available: false,
      ),
      // Adding three more books
      Book(
        id: '4',
        title: 'Zero to One',
        author: 'Peter Thiel',
        description: 'Notes on Startups, or How to Build the Future.',
        imageUrl: 'https://m.media-amazon.com/images/I/71m-lAf6abL._AC_UF1000,1000_QL80_.jpg',
        color: Colors.tealAccent,
        available: true,
      ),
      Book(
        id: '5',
        title: 'The Subtle Art of Not Giving a F*ck',
        author: 'Mark Manson',
        description: 'A Counterintuitive Approach to Living a Good Life.',
        imageUrl: 'https://m.media-amazon.com/images/I/71QKQ9mwV7L._AC_UF1000,1000_QL80_.jpg',
        color: Colors.redAccent,
        available: true,
      ),
      Book(
        id: '6',
        title: 'Educated',
        author: 'Tara Westover',
        description: 'A Memoir by Tara Westover.',
        imageUrl: 'https://m.media-amazon.com/images/I/81NwOj14S6L._AC_UF1000,1000_QL80_.jpg',
        color: Colors.amberAccent,
        available: false,
      ),
    ];

    setState(() {
      _books = dummyBooks;
      _filteredBooks = dummyBooks;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
        ),
      )
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF181A20),
            expandedHeight: 120,
            floating: false,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              title: Text(
                'Swap Shelf',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by title or author',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF23243A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return BookItem(book: _filteredBooks[index], darkMode: true);
                },
                childCount: _filteredBooks.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        onPressed: () {
          Navigator.pushNamed(context, '/add_book');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}