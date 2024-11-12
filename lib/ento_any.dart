import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EntoAny extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final String preferredLanguage;

  const EntoAny({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.preferredLanguage,
  }) : super(key: key);

  @override
  State<EntoAny> createState() => _EntoAnyState();
}

class _EntoAnyState extends State<EntoAny> {
  List<String> suggestions = [];
  // bool isLoading = false;

  // Fetch suggestions when the text field value changes
  Future<void> getSuggestions(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        suggestions = []; // Clear suggestions if input is empty
      });
      return;
    }

    setState(() {
      // isLoading = true; // Show the loading indicator
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://google.com/inputtools/request?text=$query&ime=transliteration_en_${widget.preferredLanguage}&num=4&cp=0&cs=1&ie=utf-8&oe=utf-8&a',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data[0] == 'SUCCESS') {
          setState(() {
            suggestions = List<String>.from(data[1][0][1]);
          });
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() {
        // isLoading = false; // Hide the loading indicator once the data is fetched
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Autocomplete widget for user input
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            // Fetch suggestions based on the user's input
            getSuggestions(textEditingValue.text);
            return suggestions;
          },
          onSelected: (String selection) {
            // Set the selected suggestion to the TextField
            widget.controller.text = selection;

            // After a selection, clear suggestions and stop the loading indicator
            setState(() {
              suggestions = [];
              // isLoading = false;
            });

            // Disable focus (dismiss keyboard)
            FocusScope.of(context).unfocus();
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted) {
            return TextField(
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: widget.hintText,
                labelText: widget.labelText,
              ),
            );
          },
        ),

        // // Loading indicator while fetching suggestions
        // if (isLoading)
        //   const Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: Center(child: CircularProgressIndicator()),
        //   ),
      ],
    );
  }
}
