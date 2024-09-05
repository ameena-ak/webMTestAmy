import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/product_service.dart';
import '../components/message_components.dart';
import '../const/colors_const.dart';
import '../const/design_cons.dart';
import '../model/product_modle.dart';
import '../services/cart_provider.dart';
import '../screen/product_detail_screen.dart';
import '../screen/cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  int _page = 1;
  final int _limit = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  late final ScrollController _scrollController;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _searchController.addListener(_filterProducts);
    _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  Future<void> _loadProducts() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await _productService.fetchProducts(_page, _limit);
      if (products.isEmpty) {
        setState(() {
          _hasMore = false;
        });
      }

      setState(() {
        _products.addAll(products);
        _filteredProducts = _filterProductList(_products);
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadMore() {
    if (!_hasMore || _isLoading) return;
    setState(() {
      _page++;
    });
    _loadProducts();
  }

  void _filterProducts() {
    setState(() {
      _searchQuery = _searchController.text;
      _filteredProducts = _filterProductList(_products);
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _filteredProducts = _filterProductList(_products);
      _isLoading = false;
    });
  }

  List<Product> _filterProductList(List<Product> products) {
    return products.where((product) {
      final matchesQuery =
          product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              product.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _page = 1;
      _products.clear();
      _hasMore = true;
    });
    await _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    void _addProductToCart(Product product) {
      cartProvider.add(product);
      showSnackBarSuccess(context, '${product.title} added to cart!');
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(

          children: [
            IconButton(onPressed: () {
              showLogoutConfirmationDialog(context);
            }, icon: Icon(Icons.logout)),
            SizedBox(width: 20,),
            Text('Product List'),
          ],
        ),
        centerTitle: true,
        backgroundColor: app_primary_color,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
          ),
          SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(140),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <String>[
                    'All',
                    'men\'s clothing',
                    'jewelery',
                    'electronics',
                    'women\'s clothing'
                  ].map((category) {
                    return GestureDetector(
                      onTap: () => _onCategoryChanged(category),
                      child: Container(
                        margin: EdgeInsets.only(right: 12.0),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              color: _selectedCategory == category
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: ListView.separated(
          controller: _scrollController,
          itemCount: _filteredProducts.length + (_hasMore ? 1 : 0),
          separatorBuilder: (context, index) => Divider(height: 1),
          itemBuilder: (context, index) {
            if (index == _filteredProducts.length) {
              return Center(child: CircularProgressIndicator());
            }

            final product = _filteredProducts[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: containerDecoration,
              child: ListTile(
                contentPadding: EdgeInsets.all(12.0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    product.image,
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  product.title,
                  style: textStyleProduct,
                ),
                subtitle: Text(
                  '\$${product.price}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  color: app_primary_color,
                  onPressed: () {
                    _addProductToCart(product);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
