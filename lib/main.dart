import 'package:flutter/material.dart';

import 'database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All journals
  List<Map<String, dynamic>> _journals = [];
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {

    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();


  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
      _landmarkController.text = existingJournal['landmark'];
      _mobileController.text = existingJournal['mobile'];
      _pincodeController.text = existingJournal['pincode'];

    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // this will prevent the soft keyboard from covering the text fields
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      labelText:'Enter Name',
                      hintText: 'Enter Name',
                      hintStyle: const TextStyle(
                          height: 2, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0)
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },

                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      labelText:'Enter Adrrese',
                      hintText: 'Enter Addrese',
                      hintStyle: const TextStyle(
                          height: 2, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0)
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter addrese';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _landmarkController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      labelText:'Enter Landmark',
                      hintText: 'Enter Landmark',
                      hintStyle: const TextStyle(
                          height: 2, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0)
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter landmark';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _mobileController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      labelText:'Enter Mobile Number',
                      hintText: 'Enter Mobile Number',
                      hintStyle: const TextStyle(
                          height: 2, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0)
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter mobile number';
                      }
                      if(value.length!=10){
                        return 'Please enter valid mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _pincodeController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      labelText:'Enter Pincode',
                      hintText: 'Enter Pincode',
                      hintStyle: const TextStyle(
                          height: 2, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0)
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter User information';
                      }
                      if(value.length!=6){
                        return 'Please enter valid pincode number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      // Save new journal
                      if(_formKey.currentState!.validate())
                      {
                        setState(()
                        async {
                          if (id == null) {
                            await _addItem();
                          }

                          if (id != null) {
                            await _updateItem(id);
                          }
                          Navigator.of(context).pop();
                          // Clear the text fields
                          _titleController.text = '';
                          _descriptionController.text = '';
                          _landmarkController.text='';
                          _mobileController.text='';
                          _pincodeController.text='';
                        });
                      }





                      // Close the bottom sheet

                    },
                    child: Text(id == null ? 'Create New' : 'Update'),
                  )
                ],
              ),
            ),
          ),
        ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _descriptionController.text,_landmarkController.text,_mobileController.text,_pincodeController.text);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _descriptionController.text,_landmarkController.text,_mobileController.text,_pincodeController.text);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {

    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL'),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(

          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_journals[index]['title']),

              subtitle: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Text(_journals[index]['description']),
                    Text(_journals[index]['mobile']),
                  ],
                ),
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_journals[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                      setState(() {
                        _deleteItem(_journals[index]['id']);
                      })

                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}