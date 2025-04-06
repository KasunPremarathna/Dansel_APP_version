import 'package:dansal_app/constent_values/const_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEventBottomSheet extends ConsumerStatefulWidget {
  final Function? onSuccess;

  const AddEventBottomSheet({super.key, this.onSuccess});

  static Future<void> show(BuildContext context, {Function? onSuccess}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEventBottomSheet(onSuccess: onSuccess),
    );
  }

  @override
  ConsumerState<AddEventBottomSheet> createState() =>
      _AddEventBottomSheetState();
}

class _AddEventBottomSheetState extends ConsumerState<AddEventBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otherEventController = TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();

  // Time selection variables
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool _isLoading = false;
  String _errorMessage = '';

  // Event type options
  final String dansal = "දන්සල්"; // Dansal (Sinhala)
  final String thorana = "තොරණ"; // Pirith (Sinhala)
  final String pahan_kudu = "පහන් කූඩු"; // Bana (Sinhala)
  final String other = "වෙනත්"; // Other (Sinhala)

  String selectedEventType = "දන්සල්"; // Default selection

  @override
  void dispose() {
    _otherEventController.dispose();
    _eventNameController.dispose();
    super.dispose();
  }

  // Method to show time picker
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          isStartTime
              ? _startTime ?? TimeOfDay.now()
              : _endTime ??
                  TimeOfDay.now().replacing(
                    hour: (TimeOfDay.now().hour + 1) % 24,
                  ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: mainThemeColor,
              onPrimary: Colors.white,
              onSurface: blackFontColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: mainThemeColor),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          // If end time is not set or earlier than start time, update it
          if (_endTime == null ||
              (_endTime!.hour < _startTime!.hour ||
                  (_endTime!.hour == _startTime!.hour &&
                      _endTime!.minute < _startTime!.minute))) {
            _endTime = TimeOfDay(
              hour: (_startTime!.hour + 1) % 24,
              minute: _startTime!.minute,
            );
          }
        } else {
          _endTime = picked;
        }
      });
    }
  }

  // Format time to readable string
  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return "සකසන්න"; // Set time in Sinhala
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }

  Future<void> _submitEvent() async {
    if (_formKey.currentState!.validate() && _validateTimes()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final locationName = _otherEventController.text.trim();
        final eventName = _eventNameController.text.trim();
        final eventType = selectedEventType;
        final startTime = _startTime;
        final endTime = _endTime;

        print('Adding event: $eventName at $locationName (Type: $eventType)');
        print(
          'Time: ${_formatTimeOfDay(startTime)} - ${_formatTimeOfDay(endTime)}',
        );

        // TODO: Implement actual event submission logic

        // Simulate success (replace with actual API call)
        await Future.delayed(Duration(seconds: 1));

        if (mounted) {
          // Close the bottom sheet
          Navigator.pop(context);

          // Show success message
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Event added successfully!')));

          // Call the success callback if provided
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          }
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error: ${e.toString()}';
        });
        print('Add event error: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  // Validate time selections
  bool _validateTimes() {
    if (_startTime == null || _endTime == null) {
      setState(() {
        _errorMessage = 'Please select both start and end times';
      });
      return false;
    }

    // Check if end time is after start time
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

    if (endMinutes <= startMinutes) {
      setState(() {
        _errorMessage = 'End time must be after start time';
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: keyboardSpace),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 20),

              Text(
                "අලුත් පිංකමක් එකතු කරන්න", // Add new event (Sinhala)
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: blackFontColor,
                ),
              ),
              SizedBox(height: 24),

              if (_errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Type Label
                    Text(
                      "පිංකමේ වර්ගය තෝරන්න", // Choose Type (Sinhala)
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: blackFontColor,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Radio Button Group
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: blackFontColor, width: 1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Dansal Radio Button
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text(
                                    dansal,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: dansal,
                                  groupValue: selectedEventType,
                                  activeColor: mainThemeColor,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedEventType = value!;
                                    });
                                  },
                                ),
                              ),

                              // Pirith Radio Button
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text(
                                    thorana,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: thorana,
                                  groupValue: selectedEventType,
                                  activeColor: mainThemeColor,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedEventType = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Bana Radio Button
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text(
                                    pahan_kudu,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: pahan_kudu,
                                  groupValue: selectedEventType,
                                  activeColor: mainThemeColor,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedEventType = value!;
                                    });
                                  },
                                ),
                              ),

                              // Other Radio Button
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text(
                                    other,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: other,
                                  groupValue: selectedEventType,
                                  activeColor: mainThemeColor,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedEventType = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Conditional container for "other" event type
                    if (selectedEventType == other)
                      TextFormField(
                        controller: _otherEventController,
                        decoration: InputDecoration(
                          labelText:
                              "වෙනත් පිංකමේ වර්ගය", // Location name in Sinhala
                          hintText:
                              "බක්ති ගීත, භූත ගුහාව, රූකඩ, ....", // Enter other location in Sinhala
                          labelStyle: TextStyle(color: blackFontColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: mainThemeColor,
                              width: 1,
                            ),
                          ),
                          floatingLabelStyle: TextStyle(color: mainThemeColor),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 17,
                            horizontal: 15,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the location name";
                          }
                          return null;
                        },
                      ),
                    // Conditional container for "other" event type
                    if (selectedEventType == other) SizedBox(height: 20),

                    TextFormField(
                      controller: _eventNameController,
                      decoration: InputDecoration(
                        labelText: "පිංකම", // Location name in Sinhala
                        hintText:
                            selectedEventType == dansal
                                ? "බත් දන්සල, බීම දන්සල, බෙලිමල් දන්සල, ...." // Enter location in Sinhala
                                : selectedEventType == thorana
                                ? "සාම ජාතකය, මට්ටකුණ්ඩලී කතාවස්තුව, ...." // Enter location in Sinhala
                                : selectedEventType == pahan_kudu
                                ? "කැරකෙන පහන් කූඩුව, ...." // Enter location in Sinhala
                                : "වෙනත් අවස්ථාව", // Enter other location in Sinhala
                        labelStyle: TextStyle(color: blackFontColor),
                        floatingLabelStyle: TextStyle(color: mainThemeColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: mainThemeColor,
                            width: 1,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 17,
                          horizontal: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the location name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Time selection section
                    Text(
                      "පිංකමේ වේලාව", // Event time in Sinhala
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: blackFontColor,
                      ),
                    ),
                    SizedBox(height: 10),

                    Row(
                      children: [
                        // Start time selector
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectTime(context, true),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: blackFontColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ආරම්භක වේලාව", // Start time in Sinhala
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: blackFontColor,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: mainThemeColor,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        _formatTimeOfDay(_startTime),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        // End time selector
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectTime(context, false),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: blackFontColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "අවසන් වේලාව", // End time in Sinhala
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: blackFontColor,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: mainThemeColor,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        _formatTimeOfDay(_endTime),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Container(
                      margin: EdgeInsets.only(top: 0),
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: whiteFontColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "පිංකමේ විස්තර", // Additional details in Sinhala
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText:
                                  "පිංකමේ විස්තර සඳහන් කරන්න", // Enter other details in Sinhala
                              labelStyle: TextStyle(color: blackFontColor),
                              floatingLabelStyle: TextStyle(
                                color: mainThemeColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: mainThemeColor,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    _isLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              mainThemeColor,
                            ),
                          ),
                        )
                        : ElevatedButton(
                          onPressed: _submitEvent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainThemeColor,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            "පිංකම එකතු කරන්න", // Add Event in Sinhala
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
