import 'package:adress_book/pages/address_list_page.dart';
import 'package:adress_book/pages/loading.dart';
import 'package:adress_book/pages/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/':(context) => LoadingApp(),
          '/addresslist':(context) => AddressListPage(),
          '/map':(context) => MapPage(),
        },
      )
    )
  );
}

