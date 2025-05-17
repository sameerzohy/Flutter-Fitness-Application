import 'package:fitness_app/features/auth/presentation/pages/register_3_ui.dart';
import 'package:fitness_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Register2Ui extends StatefulWidget {
  const Register2Ui({super.key});

  @override
  State<Register2Ui> createState() => _Register2UiState();
}

class _Register2UiState extends State<Register2Ui> {
  final _dobController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightControler = TextEditingController();
  final _genderController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightControler.dispose();
    _genderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(actions: []),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: IntrinsicHeight(
            child: Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Image.asset('assets/images/Register_Page_2.png'),
                    const SizedBox(height: 40),
                    const Text(
                      "Let's Complete your profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "It will help us to know more about you.",
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(height: 20),
                    GenderDropDownButton(genderController: _genderController),
                    const SizedBox(height: 20),
                    DateOfBirth(dobController: _dobController),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _weightControler,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Weight is not entered';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(182, 180, 194, 0.5),
                              prefixIcon: Icon(
                                Icons.monitor_weight_outlined,
                                color: Colors.white,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              hintText: 'Your Weight',
                            ),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 25,
                          ),
                          // height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFCC8FED), // 0%
                                Color(0xFF6B50F6), // 100%
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'KG',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Add Spacer or Expanded if needed to push content to bottom
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Height is not entered';
                              }
                              return null;
                            },
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(182, 180, 194, 0.5),
                              prefixIcon: Icon(
                                Icons.height_outlined,
                                color: Colors.white,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              hintText: 'Your Height',
                            ),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 25,
                          ),
                          // height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFCC8FED), // 0%
                                Color(0xFF6B50F6), // 100%
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'CM',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    AuthGradientButton(
                      buttonText: 'Next',
                      onPressed: () {
                        double heightm =
                            int.parse(_heightController.text) / 100;
                        heightm *= heightm;
                        double bmi = int.parse(_weightControler.text) / heightm;
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (cxt) => Register3Ui(
                                    details: {
                                      'weight': double.parse(
                                        _weightControler.text.trim(),
                                      ),
                                      'height': double.parse(
                                        _heightController.text.trim(),
                                      ),
                                      'dob': DateTime.parse(
                                        _dobController.text.trim(),
                                      ),
                                      'gender': _genderController.text,
                                      'bmi': bmi,
                                    },
                                  ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GenderDropDownButton extends StatelessWidget {
  final TextEditingController genderController;
  const GenderDropDownButton({super.key, required this.genderController});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: genderController.text.isNotEmpty ? genderController.text : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color.fromRGBO(182, 180, 194, 0.5),
        prefixIcon: const Icon(Icons.person_outline, color: Colors.white),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
        hintText: 'Gender',
      ),
      items: const [
        DropdownMenuItem(value: 'male', child: Text('Male')),
        DropdownMenuItem(value: 'female', child: Text('Female')),
        DropdownMenuItem(value: 'no_gender', child: Text('Not Prefer to Say')),
      ],
      onChanged: (String? newValue) {
        if (newValue != null) {
          genderController.text = newValue;
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Gender is not Selected";
        }
        return null;
      },
    );
  }
}

class DateOfBirth extends StatelessWidget {
  final TextEditingController dobController;
  const DateOfBirth({super.key, required this.dobController});

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: DateTime(2005, 10, 4),
    );

    if (pickedDate != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dobController,
      readOnly: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color.fromRGBO(182, 180, 194, 0.5),
        prefixIcon: const Icon(Icons.calendar_today, color: Colors.white),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
        hintText: 'Date of Birth',
      ),
      onTap: () => _selectDate(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Date of Birth is not entered';
        }
        return null;
      },
    );
  }
}
