library ento_any_dropdown;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EntoAny extends StatefulWidget {
  final TextEditingController controller; // Add this line
  final String hintText; // For hint text
  final String labelText; // For label text
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
  bool isLoading = false;
  bool userSelected = false; // Flag to track user selection

  @override
  void initState() {
    super.initState();
    // Listen to text changes
    widget.controller.addListener(() {
      if (!userSelected) {
        getSuggestions();
      }
      userSelected = false; // Reset the flag
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getSuggestions() async {
    if (widget.controller.text.trim().isEmpty) {
      setState(() {
        suggestions = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://google.com/inputtools/request?text=${widget.controller.text}&ime=transliteration_en_${widget.preferredLanguage}&num=4&cp=0&cs=1&ie=utf-8&oe=utf-8&a',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data[0] == 'SUCCESS') {
          if (mounted) {
            setState(() {
              suggestions = List<String>.from(data[1][0][1]);
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void selectSuggestion(String suggestion) {
    userSelected = true; // Mark that the user made a selection
    setState(() {
      widget.controller.text = suggestion; // Update text controller
      suggestions = []; // Clear suggestions
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: widget.hintText, // Use hint text
            labelText: widget.labelText, // Use label text
          ),
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: suggestions.map((suggestion) {
                return InkWell(
                  onTap: () => selectSuggestion(suggestion),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      suggestion,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
