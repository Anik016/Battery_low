// lib/services/product_service.dart
class ProductService {
  static Future<List<Map<String, dynamic>>> getProducts() async {
    // You can replace this with actual Supabase fetching
    return [
      {
        "name": "Cricket Bat",
        "description": "Professional cricket bat for serious players",
        "image_url": "https://anrmjtwtkajtjyidvflx.supabase.co/storage/v1/object/public/product-images/product1.jpeg",
      },
      {
        "name": "Sports Car",
        "description": "High-performance sports car",
        "image_url": "https://anrmjtwtkajtjyidvflx.supabase.co/storage/v1/object/public/product-images/product2.jpeg",
      },
      {
        "name": "Messi Jersey",
        "description": "Official Lionel Messi football jersey",
        "image_url": "https://anrmjtwtkajtjyidvflx.supabase.co/storage/v1/object/public/product-images/product3.jpeg",
      },
      {
        "name": "B2 Bomber",
        "description": "Advanced military aircraft",
        "image_url": "https://anrmjtwtkajtjyidvflx.supabase.co/storage/v1/object/public/product-images/product4.jpeg",
      },
      {
        "name": "Luxury Watch",
        "description": "Premium luxury timepiece",
        "image_url": "https://anrmjtwtkajtjyidvflx.supabase.co/storage/v1/object/public/product-images/product5.jpeg",
      },
      {
        "name": "Political Biography",
        "description": "Inspiring political journey",
        "image_url": "https://anrmjtwtkajtjyidvflx.supabase.co/storage/v1/object/public/product-images/product6.jpeg",
      },
    ];
  }
}