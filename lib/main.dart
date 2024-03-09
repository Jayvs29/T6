import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ToolBoxView(),
    GenderPredictionView(),
    AgePredictionView(),
    UniversityListView(),
    WeatherView(),
    PlayStationBlogView(),
    ContactView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarea 6'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Portada',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Género',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Edad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Universidades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'Clima de RD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web),
            label: 'Página Web',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Datos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ToolBoxView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage('assets/img/ch.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            '¡Bienvenidos a la caja de herramientas!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Esta app te permitirá hacer varias cosas dentro de ella, te invito a descubrirla.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class GenderPredictionView extends StatefulWidget {
  @override
  _GenderPredictionViewState createState() => _GenderPredictionViewState();
}

class _GenderPredictionViewState extends State<GenderPredictionView> {
  String _name = '';
  String _gender = '';
  bool _loading = false;

  Future<void> _predictGender(String name) async {
    setState(() {
      _loading = true;
    });

    final response =
        await http.get(Uri.parse('https://api.genderize.io/?name=$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _gender = data['gender'];
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to predict gender');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Ingrese un nombre',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_name.isNotEmpty) {
                _predictGender(_name);
              }
            },
            child: Text('Predecir Género'),
          ),
          SizedBox(height: 20),
          _loading
              ? CircularProgressIndicator()
              : _gender.isNotEmpty
                  ? Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _gender == 'male' ? Colors.blue : Colors.pink,
                      ),
                      child: Icon(
                        _gender == 'male' ? Icons.male : Icons.female,
                        color: Colors.white,
                        size: 50,
                      ),
                    )
                  : SizedBox(),
        ],
      ),
    );
  }
}

class AgePredictionView extends StatefulWidget {
  @override
  _AgePredictionViewState createState() => _AgePredictionViewState();
}

class _AgePredictionViewState extends State<AgePredictionView> {
  String _name = '';
  int _age = 0;
  String _ageGroup = '';
  bool _loading = false;

  Future<void> _predictAge(String name) async {
    setState(() {
      _loading = true;
    });

    final response =
        await http.get(Uri.parse('https://api.agify.io/?name=$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _age = data['age'];
        _ageGroup = _getAgeGroup(_age);
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to predict age');
    }
  }

  String _getAgeGroup(int age) {
    if (age < 18) {
      return 'joven';
    } else if (age >= 18 && age <= 65) {
      return 'adulto';
    } else {
      return 'anciano';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Ingrese un nombre',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_name.isNotEmpty) {
                _predictAge(_name);
              }
            },
            child: Text('Predecir Edad'),
          ),
          SizedBox(height: 20),
          _loading
              ? CircularProgressIndicator()
              : _age != 0
                  ? Text(
                      'La persona de nombre $_name tiene $_age años y es $_ageGroup',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )
                  : SizedBox(),
        ],
      ),
    );
  }
}

class UniversityListView extends StatefulWidget {
  @override
  _UniversityListViewState createState() => _UniversityListViewState();
}

class _UniversityListViewState extends State<UniversityListView> {
  String _countryName = '';
  List<dynamic> _universities = [];
  bool _loading = false;

  Future<void> _fetchUniversities(String countryName) async {
    setState(() {
      _loading = true;
    });

    final response = await http.get(Uri.parse(
        'http://universities.hipolabs.com/search?country=$countryName'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _universities = data;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to fetch universities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Ingrese un país en inglés',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _countryName = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_countryName.isNotEmpty) {
                _fetchUniversities(_countryName);
              }
            },
            child: Text('Buscar Universidades'),
          ),
          SizedBox(height: 20),
          _loading
              ? CircularProgressIndicator()
              : _universities.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: _universities.length,
                        itemBuilder: (context, index) {
                          final university = _universities[index];
                          return ListTile(
                            title: Text(university['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Dominio: ${university['domains'].isEmpty ? 'No disponible' : university['domains'][0]}'),
                                Text(
                                    'Página Web: ${university['web_pages'].isEmpty ? 'No disponible' : university['web_pages'][0]}'),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : SizedBox(),
        ],
      ),
    );
  }
}

class WeatherView extends StatefulWidget {
  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  String _location = '';
  double _temperature = 0;
  int _humidity = 0;
  String _description = '';
  bool _loading = true;

  Future<void> _fetchWeatherData() async {
    try {
      // Obtener la ubicación actual del dispositivo
      // Simulamos la ubicación y el clima
      setState(() {
        _location = 'República Dominicana';
        _temperature = 28.0;
        _humidity = 75;
        _description = 'Parcialmente nublado';
        _loading = false;
      });
    } catch (e) {
      print('Error al obtener la ubicación: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _loading
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Clima en $_location',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Temperatura: $_temperature°C',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Humedad: $_humidity%',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Descripción: $_description',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
    );
  }
}

class PlayStationBlogView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PlayStation Blog'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildBlogPost(
              'Spider-Man 2 de PS5',
              '¡Descubre las últimas noticias sobre Spider-Man 2 de PS5!',
              'assets/img/ha.jpg',
              'Spider-Man 2 de PS5 ha superado todas las expectativas de ventas, convirtiéndose en uno de los juegos más vendidos del año. Con gráficos impresionantes, jugabilidad fluida y una emocionante historia, este juego ofrece una experiencia inigualable para los fans de Spider-Man. Además, la última actualización incluye nuevo contenido emocionante que mantendrá a los jugadores enganchados durante horas.'),
          SizedBox(height: 20),
          _buildBlogPost(
              'God of War Ragnarok',
              '¡Entérate de todas las novedades sobre God of War Ragnarok!',
              'assets/img/gow.jpeg',
              'God of War Ragnarok promete ser el mejor juego de la saga hasta ahora. Con gráficos de última generación y una historia épica, los jugadores se preparan para embarcarse en una nueva aventura junto a Kratos y Atreus. La jugabilidad mejorada y los impresionantes escenarios hacen que este juego sea uno de los más esperados del año.'),
          SizedBox(height: 20),
          _buildBlogPost(
              'PlayStation Plus',
              '¡Aprovecha las increíbles ofertas de PlayStation Plus!',
              'assets/img/psp.jpg',
              'PlayStation Plus ofrece una excelente relación calidad-precio con sus numerosas ofertas y beneficios exclusivos para sus suscriptores. Desde juegos gratuitos hasta descuentos especiales en la tienda, los miembros de PlayStation Plus disfrutan de una amplia gama de beneficios. ¡No te pierdas la oportunidad de unirte y disfrutar de todas las ventajas que ofrece PlayStation Plus!'),
        ],
      ),
    );
  }

  Widget _buildBlogPost(
      String title, String subtitle, String imagePath, String content) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacto'),
      ),
      body: Center(
        child: ContactCard(),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 60.0,
              backgroundImage: AssetImage('assets/img/jv.jpg'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Jayson Ventura Santana',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'jvs020529@gmail.com',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
