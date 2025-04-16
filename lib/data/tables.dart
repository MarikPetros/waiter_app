class RestaurantTable {
  const RestaurantTable(
      {required this.id,
      required this.place,
      required this.furniture,
      required this.luxury});

  final int id;
  final Place place;
  final String furniture;
  final String luxury;
}

class Place {
  const Place({required this.name});

  final String name;
}

const tables = [
  RestaurantTable(
    id: 1,
    place: Place(name: 'Основной зал'),
    furniture: 'Тапчан1',
    luxury: 'Vip2',
  ),
  RestaurantTable(
    id: 2,
    place: Place(name: 'Основной зал'),
    furniture: 'Тапчан2',
    luxury: 'Vip2',
  ),
  RestaurantTable(
    id: 3,
    place: Place(name: 'Основной зал'),
    furniture: 'Стол1',
    luxury: 'Vip1',
  ),
  RestaurantTable(
      id: 4,
      place: Place(name: 'Основной зал'),
      furniture: 'Стол2',
      luxury: 'Vip1'),
  RestaurantTable(
    id: 5,
    place: Place(name: 'Летка'),
    furniture: 'Стол1',
    luxury: 'Vip1',
  ),
  RestaurantTable(
    id: 6,
    place: Place(name: 'Летка'),
    furniture: 'Тапчан1',
    luxury: 'Vip2',
  ),
];
