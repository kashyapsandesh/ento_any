# EntoAny

**EntoAny** is a Flutter package for easy text transliteration. It allows users to input text and receive transliterated suggestions based on their preferred language.

## Features

- **Text Input**: Users can enter text into the input field.
- **Transliteration Suggestions**: The package fetches transliteration suggestions based on user input.
- **Preferred Language Selection**: Easily set the preferred language for transliteration.
- **Customizable UI**: The widget can be customized with hints and labels.

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  ento_any: ^1.0.0 # Replace with the latest version
```

Then run:

```bash
flutter pub get
```

## Usage

Here’s a simple example of how to use the `EntoAny` widget in your Flutter application:

```dart
import 'package:flutter/material.dart';
import 'package:ento_any/ento_any.dart'; // Adjust the import based on your package location

class CheckIntoAny extends StatefulWidget {
  const CheckIntoAny({super.key});

  @override
  State<CheckIntoAny> createState() => _CheckIntoAnyState();
}

class _CheckIntoAnyState extends State<CheckIntoAny> {
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose(); // Dispose the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transliterator Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: EntoAny(
                preferredLanguage: 'ne', // Set the preferred language (e.g., Nepali)
                hintText: 'Enter text to transliterate',
                labelText: 'Text',
                controller: textController,
              ),
            ),
            const SizedBox(height: 20),
            // Display the selected text
            Text(
              'Selected Text: ${textController.text}', // Show the selected text
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Send the text to the server
                print(textController.text);
              },
              child: Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Parameters

- `preferredLanguage`: Specify the preferred language for transliteration (e.g., `'ne'` for Nepali).
- `hintText`: The placeholder text displayed in the input field.
- `labelText`: The label for the input field.
- `controller`: A `TextEditingController` to manage the text input.

## Contribution

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Feel free to customize this README further based on your needs or specific features of your package!