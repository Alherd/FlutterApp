import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON ADVANCED',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Scaffold(
        appBar: AppBar(
          title: Text('JSON'),
        ),
        body: Center(
            child: FutureBuilder<List<User>>(
                future: fetchListUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<User> users = snapshot.data;
                    return new ListView(
                        children: users
                            .map((user) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('UserName: ${user.username}'),
                                    Text('Name: ${user.name}'),
                                    Text(
                                        'Lat/Lng: ${user.address.geo.lat}/${user.address.geo.lng}'),
                                    new Divider()
                                  ],
                                ))
                            .toList());
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return new CircularProgressIndicator();
                })),
      ),
    );
  }
}

Future<List<User>> fetchListUser() async {
  final response = await http.get('http://jsonplaceholder.typicode.com/users');

  if (response.statusCode == 200) {
    List users = json.decode(response.body);
    return users.map((user) => new User.fromJson(user)).toList();
  } else
    throw Exception('Failed to load Users');
}
/*
{
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": {
      "street": "Kulas Light",
      "suite": "Apt. 556",
      "city": "Gwenborough",
      "zipcode": "92998-3874",
      "geo": {
        "lat": "-37.3159",
        "lng": "81.1496"
      }
    },
    "phone": "1-770-736-8031 x56442",
    "website": "hildegard.org",
    "company": {
      "name": "Romaguera-Crona",
      "catchPhrase": "Multi-layered client-server neural-net",
      "bs": "harness real-time e-markets"
    }
  },
 */

class User {
  final int id;
  final String name, username, email, phone, website;
  final Address address;
  final Company company;

  User(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.phone,
      this.website,
      this.address,
      this.company});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        username: json['username'],
        phone: json['phone'],
        website: json['website'],
        address: Address.fromJson(json['address']),
        company: Company.fromJson(json['company']));
  }
}

class Address {
  final String street;
  final String suite;
  final String zipcode;
  final Geo geo;

  Address({this.street, this.suite, this.zipcode, this.geo});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        street: json['street'],
        suite: json['suite'],
        zipcode: json['zipcode'],
        geo: Geo.fromJson(json['geo']));
  }
}

class Geo {
  final String lat, lng;

  Geo({this.lat, this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(lat: json['lat'], lng: json['lng']);
  }
}

class Company {
  final String name;
  final String catchPhase;
  final String bs;

  Company({this.name, this.catchPhase, this.bs});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
        name: json['name'], catchPhase: json['catchPhrase'], bs: json['bs']);
  }
}
