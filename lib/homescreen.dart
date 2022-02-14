import 'package:flutter/material.dart';
import 'package:helper/contact.dart';
import 'package:helper/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Contact _contact = Contact();
  List<Contact> _contacts = [];
  DatabaseHelper? _dbHelper;
  bool valid=true;

  final _ctrlName = TextEditingController();
  final _ctrlMobile = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    _refreshContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: [_form(), _list()],
          ),
        ),
      ),
    );
  }

  _form() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(validator: (value) {
               if (value == null || value.isEmpty) {
                      return 'Please enter some text';}
                       return null;
            },
              controller: _ctrlName,
              onSaved: (val) => setState(() {
                _contact.name = val;
              }),
              decoration: InputDecoration(labelText: 'FullName'),
            ),
            TextFormField(validator: (value) {
               if (value == null || value.isEmpty) {
                      return 'Please enter some text';}
                       return null;
            },
              controller: _ctrlMobile,
              onSaved: (val) => setState(() {
                _contact.mobile = val;
              }),
              decoration: InputDecoration(labelText: 'Mobile'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: onSubmit, child: Text('Submit')),
            )
          ],
        ),
      ),
    );
  }

  _list() {
    return Expanded(
      child: Card(
          child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      trailing: IconButton(
                          onPressed: () async{
                            await _dbHelper?.deleteContact(_contacts[index].id!);
                            _resetForm();
                            _refreshContactList();
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                      leading: IconButton(
                          onPressed: () {}, icon: Icon(Icons.account_circle)),
                      title: _contacts[index].name == null
                          ? Text('null')
                          : Text(_contacts[index].name!),
                      subtitle: _contacts[index].mobile == null
                          ? Text('null')
                          : Text(_contacts[index].mobile!),
                      onTap: () {
                        setState(() {
                          _contact = _contacts[index];
                          _ctrlName.text = _contacts[index].name!;
                          _ctrlMobile.text = _contacts[index].mobile!;
                        });
                      },
                    )
                  ],
                );
              })),
    );
  }

  _refreshContactList() async {
    List<Contact> x = await _dbHelper!.fetchContacts();
    setState(() {
      _contacts = x;
    });
  }

  void onSubmit() async {
   if(_formKey.currentState!.validate()){
var form = _formKey.currentState;
    form!.save();
    if (_contact.id == null) {
      await _dbHelper!.insertContact(_contact);
    } else {
      await _dbHelper!.updateContact(_contact);
    }
    _refreshContactList();
    _resetForm();
  
   }
  }

  _resetForm() {
    setState(() {
      var form = _formKey.currentState;
      form!.reset();
      _ctrlName.clear();
      _ctrlMobile.clear();
      _contact.id = null;
    });
  }
}
