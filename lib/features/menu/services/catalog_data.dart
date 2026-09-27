import '../models/category_model.dart';
import '../models/menu_item.dart';
import '../models/momo_model.dart';
import '../models/pizza_model.dart';

/// Catalog data source.
///
/// Ported and merged from `service/category_data.dart`, `service/pizza_data.dart`,
/// and `service/momo_data.dart`. Raw per-category models are exposed via the
/// legacy getters; [allItems]/[findItem] normalize them into [MenuItem] values
/// with stable ids for route lookup.
List<CategoryModel> getCategories() {
  const entries = [
    ("Pizza", "images/category/pizza.png"),
    ("Momo", "images/category/momos.png"),
    ("Bibimbap", "images/category/bibimbap.png"),
    ("KFC", "images/category/fried-chicken.png"),
    ("Pasta", "images/category/paella.png"),
    ("Ramen", "images/category/ramen.png"),
    ("Rice", "images/category/rice.png"),
    ("Spaguetti", "images/category/spaguetti.png"),
    ("Taco", "images/category/taco.png"),
  ];

  return [for (final e in entries) CategoryModel()..name = e.$1..image = e.$2];
}

List<PizzaModel> getPizza() {
  return _repeat(
    () => [
      PizzaModel()
        ..name = "Cheese Pizza"
        ..image = "images/pizza/cheesepizza.jpeg"
        ..price = "200"
        ..description =
            "A classic favorite made with a golden, crispy\ncrust topped with rich tomato sauce and a\ngenerous layer of melted mozzarella cheese.\nPerfectly baked to deliver a gooey, cheesy\ndelight in every bite.",
      PizzaModel()
        ..name = "Margherita Pizza"
        ..image = "images/pizza/margheritapizza.jpeg"
        ..price = "250"
        ..description =
            "Margherita Pizza is a classic Italian pizza topped with fresh tomato sauce, mozzarella cheese, and basil leaves, offering a simple yet delicious balance of flavors.",
      PizzaModel()
        ..name = "Mix Pizza"
        ..image = "images/pizza/mixpizza.jpeg"
        ..price = "300"
        ..description =
            "Mix Pizza is a flavorful combination topped with a variety of ingredients like vegetables, meats, and cheese, creating a rich and satisfying taste in every slice.",
    ],
  );
}

List<MomoModel> getMomo() {
  return _repeat(
    () => [
      MomoModel()
        ..name = "Fried Momo"
        ..image = "images/momo/FriedMomo.png"
        ..price = "200"
        ..description = "",
      MomoModel()
        ..name = "Jhol Momo"
        ..image = "images/momo/jholmomo.jpeg"
        ..price = "250"
        ..description = "",
      MomoModel()
        ..name = "Steam Momo"
        ..image = "images/momo/steammomo.jpeg"
        ..price = "300"
        ..description = "",
    ],
  );
}

List<T> _repeat<T>(List<T> Function() factory) => [
      ...factory(),
      ...factory(),
      ...factory(),
    ];

/// All catalog items flattened with stable ids: `pizza-<index>`, `momo-<index>`.
List<MenuItem> get allItems => [
      for (final e in getPizza().indexed)
        MenuItem(
          id: 'pizza-${e.$1}',
          name: e.$2.name!,
          image: e.$2.image!,
          price: e.$2.price!,
          description: e.$2.description!,
        ),
      for (final e in getMomo().indexed)
        MenuItem(
          id: 'momo-${e.$1}',
          name: e.$2.name!,
          image: e.$2.image!,
          price: e.$2.price!,
          description: e.$2.description!,
        ),
    ];

/// MenuItems belonging to the given category index (`"0"` = pizza, `"1"` = momo).
List<MenuItem> itemsForCategory(String categoryIndex) {
  if (categoryIndex == "1") {
    return [
      for (final e in getMomo().indexed)
        MenuItem(
          id: 'momo-${e.$1}',
          name: e.$2.name!,
          image: e.$2.image!,
          price: e.$2.price!,
          description: e.$2.description!,
        ),
    ];
  }
  return [
    for (final e in getPizza().indexed)
      MenuItem(
        id: 'pizza-${e.$1}',
        name: e.$2.name!,
        image: e.$2.image!,
        price: e.$2.price!,
        description: e.$2.description!,
      ),
  ];
}

MenuItem? findItem(String id) {
  for (final item in allItems) {
    if (item.id == id) return item;
  }
  return null;
}