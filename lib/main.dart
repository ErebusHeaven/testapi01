import 'package:flutter/material.dart';
import 'apiservice.dart';
import 'product_model.dart';

void main() { runApp(const MyApp()); }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Product List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = ApiService.fetchProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _products = ApiService.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProducts,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: FutureBuilder<List<Product>>(
          future: _products,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No products found'),
              );
            }

            final products = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // รูปสินค้า
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(12),
                        ),
                        child: product.imageUrl.isNotEmpty
                            ? Image.network(
                          product.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // ข้อมูลสินค้า
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                product.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                '฿ ${product.price}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );

            // return GridView.builder(
            //   padding: const EdgeInsets.all(8),
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,        // จำนวนคอลัมน์
            //     crossAxisSpacing: 8,      // ระยะห่างแนวนอน
            //     mainAxisSpacing: 8,       // ระยะห่างแนวตั้ง
            //     childAspectRatio: 0.75,   // ปรับความสูงการ์ด
            //   ),
            //   itemCount: products.length,
            //   itemBuilder: (context, index) {
            //     final product = products[index];
            //
            //     return Card(
            //       elevation: 2,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           // รูปสินค้า
            //           ClipRRect(
            //             borderRadius: const BorderRadius.vertical(
            //               top: Radius.circular(12),
            //             ),
            //             child: product.imageUrl.isNotEmpty
            //                 ? Image.network(
            //               product.imageUrl,
            //               height: 120,
            //               width: double.infinity,
            //               fit: BoxFit.cover,
            //             )
            //                 : Container(
            //               height: 120,
            //               width: double.infinity,
            //               color: Colors.grey.shade300,
            //               child: const Icon(Icons.image_not_supported),
            //             ),
            //           ),
            //
            //           Padding(
            //             padding: const EdgeInsets.all(8),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   product.name,
            //                   maxLines: 1,
            //                   overflow: TextOverflow.ellipsis,
            //                   style: const TextStyle(
            //                     fontSize: 14,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //
            //                 const SizedBox(height: 4),
            //
            //                 Text(
            //                   product.description,
            //                   maxLines: 2,
            //                   overflow: TextOverflow.ellipsis,
            //                   style: TextStyle(
            //                     fontSize: 12,
            //                     color: Colors.grey.shade600,
            //                   ),
            //                 ),
            //
            //                 const SizedBox(height: 6),
            //
            //                 Text(
            //                   '฿ ${product.price}',
            //                   style: const TextStyle(
            //                     fontSize: 13,
            //                     fontWeight: FontWeight.w600,
            //                     color: Colors.deepPurple,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // );



          },
        ),
      ),
    );
  }
}
