import 'package:dansal_app/constent_values/const_colors.dart';
import 'package:flutter/material.dart';

class EventAddScreeen extends StatefulWidget {
  const EventAddScreeen({super.key});

  @override
  State<EventAddScreeen> createState() => _EventAddScreeenState();
}

class _EventAddScreeenState extends State<EventAddScreeen> {

  bool moveToBottom = false; //Flag to track the position

  String dansal = "දන්සල්";//assign sinhala font to the variable  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: mainThemeColor),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 30),

                //DropdownButton container
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: whiteFontColor,
                  ),
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(20),
                    hint: Text("වර්ගය තෝරන්න"),
                    items:
                        [dansal, "වෙනත් වර්ගයක් එකතු කරන්න"].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue == dansal) {
                        setState(() {
                          moveToBottom = false; // Move TextFormField to bottom
                        });
                      } else {
                        setState(() {
                          moveToBottom = true; // Move TextFormField up
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          // AnimatedPositioned for moving TextFormField
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.bounceInOut,
            left: 20,
            right: 20,
            bottom:
                moveToBottom ? 20 : null, // If moveToBottom is true, go down
            top: moveToBottom ? null : 100, // If moveToBottom is false, stay up
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    labelText: "ස්ඨානයේ නම",
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    labelText: "අවස්තාවේ නම",
                  ),
                ),
              ],
            ),
          ),
          // New TextBox - Only visible when TextFormField is at the bottom
          if (moveToBottom) // Conditionally render new text box
            Positioned(
              left: 20,
              right: 20,
              bottom: 80,  // Place it above the first text field
              child: Container(
                width: double.infinity,
                height: 200,
                color: whiteFontColor,
              )
            ),
        ],
      ),
    );
  }
}
