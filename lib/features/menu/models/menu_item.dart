/// A catalog item as presented in the UI and detail route.
///
/// Normalizes the per-category raw models ([PizzaModel], [MomoModel]) into a
/// single value with a stable [id] used by the `/item/:id` route.
class MenuItem {
  final String id;
  final String name;
  final String image;
  final String price;
  final String description;

  const MenuItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
  });

  int get priceValue => int.tryParse(price) ?? 0;
}