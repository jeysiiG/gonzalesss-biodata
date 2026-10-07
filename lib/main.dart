import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Biodata",
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfff1f3f5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff606770),
        ),
        fontFamily: "Arial",
      ),
      home: const BiodataPage(),
    );
  }
}

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});

  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  final name = TextEditingController();
  final age = TextEditingController();
  final birthday = TextEditingController();
  final address = TextEditingController();
  final email = TextEditingController();
  final contact = TextEditingController();

  String gender = "Male";

  void saveBiodata() async {
    if (name.text.isEmpty ||
        age.text.isEmpty ||
        birthday.text.isEmpty ||
        address.text.isEmpty ||
        email.text.isEmpty ||
        contact.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill up all fields."),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("biodata").add({
      "name": name.text,
      "age": age.text,
      "birthday": birthday.text,
      "address": address.text,
      "email": email.text,
      "contact": contact.text,
      "gender": gender,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Biodata saved successfully!"),
      ),
    );

    name.clear();
    age.clear();
    birthday.clear();
    address.clear();
    email.clear();
    contact.clear();
  }

  Widget textField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: const Color(0xff606770),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffd0d4d8),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffd0d4d8),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xff606770),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xffe0e0e0),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xff606770),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff343a40),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xff707780),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget biodataPreview() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xffd5d9dd),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xffeef0f2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xffd5d9dd),
                  child: Icon(
                    Icons.person,
                    size: 45,
                    color: Color(0xff606770),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.text.isEmpty ? "Your Name" : name.text,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff252a2e),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Personal Information",
                        style: TextStyle(
                          color: Color(0xff707780),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          infoRow(Icons.person, "Full Name",
              name.text.isEmpty ? "-" : name.text),
          infoRow(Icons.calendar_today, "Age",
              age.text.isEmpty ? "-" : age.text),
          infoRow(Icons.cake, "Birthday",
              birthday.text.isEmpty ? "-" : birthday.text),
          infoRow(Icons.location_on, "Address",
              address.text.isEmpty ? "-" : address.text),
          infoRow(Icons.email, "Email",
              email.text.isEmpty ? "-" : email.text),
          infoRow(Icons.phone, "Contact Number",
              contact.text.isEmpty ? "-" : contact.text),
          infoRow(Icons.male, "Gender", gender),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff606770),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "My Biodata",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xff606770),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: Color(0xff606770),
                        ),
                      ),
                      SizedBox(width: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My Biodata",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Personal Information",
                            style: TextStyle(
                              color: Color(0xffe0e0e0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 750) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: biodataForm(),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: biodataPreview(),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        biodataForm(),
                        const SizedBox(height: 20),
                        biodataPreview(),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget biodataForm() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xffd5d9dd),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.description,
                color: Color(0xff606770),
              ),
              SizedBox(width: 10),
              Text(
                "Biodata Form",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff252a2e),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          textField(
            "Full Name",
            name,
            Icons.person,
          ),

          textField(
            "Age",
            age,
            Icons.calendar_today,
          ),

          textField(
            "Birthday",
            birthday,
            Icons.cake,
          ),

          textField(
            "Address",
            address,
            Icons.location_on,
          ),

          textField(
            "Email",
            email,
            Icons.email,
          ),

          textField(
            "Contact Number",
            contact,
            Icons.phone,
          ),

          DropdownButtonFormField<String>(
            value: gender,
            decoration: InputDecoration(
              labelText: "Gender",
              prefixIcon: const Icon(
                Icons.male,
                color: Color(0xff606770),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: "Male",
                child: Text("Male"),
              ),
              DropdownMenuItem(
                value: "Female",
                child: Text("Female"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                gender = value!;
              });
            },
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: saveBiodata,
              icon: const Icon(Icons.save),
              label: const Text(
                "SAVE BIODATA",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff606770),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    name.dispose();
    age.dispose();
    birthday.dispose();
    address.dispose();
    email.dispose();
    contact.dispose();
    super.dispose();
  }
}