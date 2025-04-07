import 'dart:io';

void main() {
  print("🛒 Hello from Ecommerce\n");
  Ecommerce ecommerce = Ecommerce(name: "Shop1");

  while (true) {
    ecommerce.printOptions();
    int choice = ecommerce.getInput<int>(
      prompt: "Enter your choice (1-6):",
      validator: numberValidator(1, 6),
    );
    switch (choice) {
      case 1:
        ecommerce.show();
        break;
      case 2:
        ecommerce.add();
        break;
      case 3:
        ecommerce.edit();
        break;
      case 4:
        ecommerce.buy();
        break;
      case 5:
        ecommerce.sell();
        break;
      case 6:
        print("\n👋 See You Back!\n");
        exit(0);
      default:
        print("\n❌ Invalid choice! Please select a valid option.\n");
    }
  }
}

class Product {
  String name;
  double price;
  int quantity;
  String category;

  Product({
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
  });
}

class Ecommerce {
  String name;
  Map<String, List<Product>> _categoryProducts = {};

  Ecommerce({required this.name});

  void printOptions() {
    print("\n📌 Ecommerce Menu:");
    print("1️⃣ Show Products");
    print("2️⃣ Add Product");
    print("3️⃣ Edit Product");
    print("4️⃣ Buy Product");
    print("5️⃣ Sell Product");
    print("6️⃣ Exit");
  }

  void show() {
    if (_categoryProducts.isEmpty) {
      print("❌ No products available.");
      return;
    }
    print("\n📦 Products by Category:");
    _categoryProducts.forEach((category, products) {
      print("\n📁 Category: $category");
      for (int i = 0; i < products.length; i++) {
        var p = products[i];
        print(
            "  ${i + 1}. 🛍️ ${p.name} - 💰 \$${p.price.toStringAsFixed(2)} - 📦 Qty: ${p.quantity}");
      }
    });
  }

  void add() {
    print("Enter product name:");
    String name = getInput<String>(
      validator: (input) => input.isNotEmpty ? input : null,
    );

    print("Enter product price:");
    double price = getInput<double>(
      validator: (input) => double.tryParse(input),
    );

    print("Enter product quantity:");
    int quantity = getInput<int>(
      validator: (input) => int.tryParse(input),
    );

    print("Enter category name:");
    String category = getInput<String>(
      validator: (input) => input.isNotEmpty ? input : null,
    );

    _categoryProducts.putIfAbsent(category, () => []);
    _categoryProducts[category]!.add(
      Product(name: name, price: price, quantity: quantity, category: category),
    );

    print("✅ Product added to category '$category' successfully!");
  }

  void edit() {
    if (_categoryProducts.isEmpty) {
      print("❌ No products to edit.");
      return;
    }

    print("Enter category name to edit from:");
    String category = getInput<String>(
      validator: (input) => _categoryProducts.containsKey(input) ? input : null,
    );

    List<Product> products = _categoryProducts[category]!;

    for (int i = 0; i < products.length; i++) {
      print(
          "${i + 1}. 🛍️ ${products[i].name} - \$${products[i].price} - Qty: ${products[i].quantity}");
    }

    int index = getInput<int>(
      prompt: "Enter product number to edit:",
      validator: (input) {
        int? i = int.tryParse(input);
        if (i != null && i > 0 && i <= products.length) return i;
        return null;
      },
    );

    var product = products[index - 1];

    print("Enter new name (or press Enter to keep '${product.name}'):");
    String? newName = stdin.readLineSync();
    if (newName != null && newName.trim().isNotEmpty) {
      product.name = newName.trim();
    }

    print("Enter new price (or press Enter to keep ${product.price}):");
    String? newPrice = stdin.readLineSync();
    if (newPrice != null && newPrice.trim().isNotEmpty) {
      double? parsed = double.tryParse(newPrice);
      if (parsed != null) product.price = parsed;
    }

    print("Enter new quantity (or press Enter to keep ${product.quantity}):");
    String? newQty = stdin.readLineSync();
    if (newQty != null && newQty.trim().isNotEmpty) {
      int? parsed = int.tryParse(newQty);
      if (parsed != null) product.quantity = parsed;
    }

    print("✅ Product updated.");
  }

  void buy() {
    if (_categoryProducts.isEmpty) {
      print("❌ No products to buy.");
      return;
    }

    print("Enter category to buy from:");
    String category = getInput<String>(
      validator: (input) => _categoryProducts.containsKey(input) ? input : null,
    );

    List<Product> products = _categoryProducts[category]!;

    for (int i = 0; i < products.length; i++) {
      print(
          "${i + 1}. 🛍️ ${products[i].name} - \$${products[i].price} - Qty: ${products[i].quantity}");
    }

    int index = getInput<int>(
      prompt: "Enter product number to buy:",
      validator: (input) {
        int? i = int.tryParse(input);
        if (i != null && i > 0 && i <= products.length) return i;
        return null;
      },
    );

    Product selected = products[index - 1];

    print("Enter quantity to buy:");
    int quantity = getInput<int>(
      validator: (input) {
        int? q = int.tryParse(input);
        if (q != null && q > 0 && q <= selected.quantity) return q;
        return null;
      },
    );

    selected.quantity -= quantity;
    print("🛒 You bought $quantity x ${selected.name}.");
  }

  void sell() {
    if (_categoryProducts.isEmpty) {
      print("❌ No products to restock.");
      return;
    }

    print("Enter category to restock from:");
    String category = getInput<String>(
      validator: (input) => _categoryProducts.containsKey(input) ? input : null,
    );

    List<Product> products = _categoryProducts[category]!;

    for (int i = 0; i < products.length; i++) {
      print(
          "${i + 1}. 🛍️ ${products[i].name} - \$${products[i].price} - Qty: ${products[i].quantity}");
    }

    int index = getInput<int>(
      prompt: "Enter product number to restock:",
      validator: (input) {
        int? i = int.tryParse(input);
        if (i != null && i > 0 && i <= products.length) return i;
        return null;
      },
    );

    Product selected = products[index - 1];

    print("Enter quantity to add:");
    int quantity = getInput<int>(
      validator: (input) {
        int? q = int.tryParse(input);
        if (q != null && q > 0) return q;
        return null;
      },
    );

    selected.quantity += quantity;
    print("📦 You restocked $quantity x ${selected.name}.");
  }

  T getInput<T>({String? prompt, required T? Function(String) validator}) {
    while (true) {
      if (prompt != null) stdout.write("$prompt ");
      String? input = stdin.readLineSync()?.trim();

      if (input == null || input.isEmpty) {
        print("❌ Input cannot be empty! Try again.");
        continue;
      }

      T? validated = validator(input);
      if (validated != null) return validated;

      print("❌ Invalid input! Try again.");
    }
  }
}

T? Function(String) numberValidator<T extends num>(int min, int max) {
  return (input) {
    T? value =
        T == int ? int.tryParse(input) as T? : double.tryParse(input) as T?;
    if (value != null && value >= min && value <= max) return value;
    return null;
  };
}
