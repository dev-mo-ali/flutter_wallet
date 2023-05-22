import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryDialog extends StatelessWidget {
  const CountryDialog({super.key});
  Future<List> readCountries() async {
    return jsonDecode(await rootBundle.loadString('assets/country_codes.json'));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: FutureBuilder(
            future: readCountries(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => Navigator.of(context).pop(snapshot.data![index]
                            ['dialling_code']
                        .replaceAll('+', '')),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.outline))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              snapshot.data![index]['name'],
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color!,
                                  fontSize: 19),
                              softWrap: true,
                            ),
                          ),
                          Text(
                            snapshot.data![index]['dialling_code'],
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color!,
                                fontSize: 19),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Container();
            })),
      ),
    );
  }
}
