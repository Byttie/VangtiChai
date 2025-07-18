import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState(); // StatefulWidget is a widget that has a state that can change.
}

class _HomePageState extends State<HomePage> {
  
  String currentAmount = '0'; // The current amount of money entered by the user
  Map<int, int> changeNotes = {}; // A map to store the number of notes of each denomination
  final List<int> takaNotes = [500, 100, 50, 20, 10, 5, 2, 1]; // The denominations of the notes

  // Event Handlers

  void addDigit(String digit) {
    setState(() { // setState is a method that tells the widget to rebuild itself.
      if (currentAmount == '0') {
        currentAmount = digit;
      } else {
        currentAmount += digit;
      }
      calculateChange();
    });
  }

  void clearAmount() {
    setState(() {
      currentAmount = '0';
      changeNotes.clear();
    });
  }

  void calculateChange() {
    int amount = int.tryParse(currentAmount) ?? 0;
    changeNotes.clear();
    
    for (int note in takaNotes) {
      if (amount >= note) {
        int count = amount ~/ note;
        changeNotes[note] = count;
        amount = amount % note;
      }
    }
  }

  // UI Components

  Widget buildNumericKeypad() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        // Row 1: 1, 2, 3
        _buildKeypadButton('1'),
        _buildKeypadButton('2'),
        _buildKeypadButton('3'),
        // Row 2: 4, 5, 6
        _buildKeypadButton('4'),
        _buildKeypadButton('5'),
        _buildKeypadButton('6'),
        // Row 3: 7, 8, 9
        _buildKeypadButton('7'),
        _buildKeypadButton('8'),
        _buildKeypadButton('9'),
        // Row 4: Clear, 0, (empty)
        _buildClearButton(),
        _buildKeypadButton('0'),
        const SizedBox(), // Empty space
      ],
    );
  }

  Widget _buildKeypadButton(String digit) {
    return ElevatedButton(
      onPressed: () => addDigit(digit),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        digit,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }


  Widget _buildClearButton() {
    return ElevatedButton(
      onPressed: clearAmount,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'C',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildChangeTable() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Change Breakdown:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...changeNotes.entries.map((entry) {
            if (entry.value > 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '৳${entry.key}:',
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${entry.value} notes',
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }).toList(),
          if (changeNotes.isEmpty)
            const Text(
              'Enter an amount to see change breakdown',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget buildPortraitLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Amount display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Text(
                  'Taka: ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    '৳$currentAmount',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Main content area
          Expanded(
            child: Row(
              children: [
                // Change table (left side)
                Expanded(
                  flex: 1,
                  child: buildChangeTable(),
                ),
                const SizedBox(width: 8),
                // Numeric keypad (right side)
                Expanded(
                  flex: 2,
                  child: buildNumericKeypad(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLandscapeLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Amount display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Text(
                  'Taka: ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    '৳$currentAmount',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Main content area
          Expanded(
            child: Row(
              children: [
                // Change table (left side)
                Expanded(
                  flex: 2,
                  child: buildChangeTable(),
                ),
                const SizedBox(width: 8),
                // Numeric keypad (right side)
                Expanded(
                  flex: 3,
                  child: buildNumericKeypad(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vangti Chai'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return buildPortraitLayout();
          } else {
            return buildLandscapeLayout();
          }
        },
      ),
    );
  }
}
