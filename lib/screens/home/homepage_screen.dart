import 'package:flutter/material.dart';
import 'package:swap_shelf/models/book.dart';
import 'package:swap_shelf/widgets/book_item.dart';
import 'package:swap_shelf/screens/swap/swap_requests_list.dart';
import 'package:swap_shelf/screens/notifications/notifications_screen.dart';
import 'package:swap_shelf/screens/Chat/chat_list_screen.dart';

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
  int _selectedIndex = 0;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Fiction',
    'Non-Fiction',
    'Science',
    'History',
    'Biography'
  ];

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home page
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
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
              body: const SwapRequestsList(),
            ),
          ),
        ).then((_) {
          setState(() {
            _selectedIndex = 0;
          });
        });
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatListScreen(),
          ),
        ).then((_) {
          setState(() {
            _selectedIndex = 0;
          });
        });
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationsScreen(),
          ),
        ).then((_) {
          setState(() {
            _selectedIndex = 0;
          });
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadBooks,
              color: const Color(0xFF6C63FF),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    elevation: 0,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.person, color: Color(0xFF6C63FF)),
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
                          color: Color(0xFF6C63FF),
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
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'Search by title or author',
                          hintStyle: const TextStyle(color: Colors.black54),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF6C63FF)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF6C63FF)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = category == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: const Color(0xFF6C63FF),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                          );
                        },
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
                          return BookItem(book: _filteredBooks[index], darkMode: false);
                        },
                        childCount: _filteredBooks.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        onPressed: () {
          Navigator.pushNamed(context, '/add_book');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Swaps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}