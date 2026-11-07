/// Model layer: raw cruise data with no UI code or mutable state.
class CruiseDestination {
  const CruiseDestination({
    required this.name,
    required this.location,
    required this.description,
    required this.imagePath,
    required this.imageCaption,
    required this.initialStarCount,
    required this.packages,
  });

  final String name;
  final String location;
  final String description;
  final String imagePath;
  final String imageCaption;
  final int initialStarCount;
  final List<String> packages;

  static const CruiseDestination rajangRiver = CruiseDestination(
    name: 'Rajang River Express Cruise',
    location: 'Sibu Waterfront, Sarawak',
    description:
        "Experience the heart of Sibu along Malaysia's longest river, the "
        'Rajang. Cruise past historic temples, timber hubs, and traditional '
        'waterfront settlements while experiencing authentic Sarawakian '
        'hospitality.',
    imagePath: 'assets/images/rajang_river.jpg',
    imageCaption: 'Sibu Esplanade Landmark',
    initialStarCount: 43,
    packages: [
      'Private River Cruise',
      'Sunset Cruise',
      'Sunrise Cruise',
      'Rural Cruise',
      'SMI Park Cruise',
    ],
  );
}
