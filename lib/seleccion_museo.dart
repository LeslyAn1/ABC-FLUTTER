import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeleccionMuseosScreen extends StatefulWidget {
  @override
  _SeleccionMuseosScreenState createState() => _SeleccionMuseosScreenState();
}

class _SeleccionMuseosScreenState extends State<SeleccionMuseosScreen> {
  String? _selectedState;
  String? _selectedMuseum;
  String? _selectedVisitorType;
  String? _selectedMonth;

  List<String> _states = [];
  List<String> _museums = [];
  List<String> _visitorTypes = [];
  List<String> _months = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Fetch states
    QuerySnapshot stateSnapshot = await FirebaseFirestore.instance.collection('Estado').get();
    _states = stateSnapshot.docs.map((doc) => doc['NombreEstado'] as String).toList();

    // Fetch museums
    QuerySnapshot museumSnapshot = await FirebaseFirestore.instance.collection('Museo').get();
    _museums = museumSnapshot.docs.map((doc) => doc['NombreMuseo'] as String).toList();

    // Fetch visitor types
    QuerySnapshot visitorTypeSnapshot = await FirebaseFirestore.instance.collection('TipoVisitantes').get();
    _visitorTypes = visitorTypeSnapshot.docs.map((doc) => doc['Modalidad'] as String).toList();

    // Fetch months
    QuerySnapshot monthSnapshot = await FirebaseFirestore.instance.collection('Mes').get();
    _months = monthSnapshot.docs.map((doc) => doc['NombreMes'] as String).toList();

    setState(() {});
  }

  void _generateTicket() {
    if (_selectedState != null &&
        _selectedMuseum != null &&
        _selectedVisitorType != null &&
        _selectedMonth != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Entrada Generada'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Estado: $_selectedState'),
              Text('Nombre de Museo: $_selectedMuseum'),
              Text('Tipo de Visitante: $_selectedVisitorType'),
              Text('Cupón válido por: $_selectedMonth'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    } else {
      // Handle incomplete selection error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Museo'),
      ),
      body: _states.isEmpty || _museums.isEmpty || _visitorTypes.isEmpty || _months.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButton<String>(
                    hint: Text('Seleccione un Estado'),
                    value: _selectedState,
                    items: _states.map((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedState = newValue;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    hint: Text('Seleccione Nombre de Museo'),
                    value: _selectedMuseum,
                    items: _museums.map((String museum) {
                      return DropdownMenuItem<String>(
                        value: museum,
                        child: Text(museum),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedMuseum = newValue;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    hint: Text('Seleccione Tipo de Visitante'),
                    value: _selectedVisitorType,
                    items: _visitorTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedVisitorType = newValue;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    hint: Text('Seleccione Mes'),
                    value: _selectedMonth,
                    items: _months.map((String month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedMonth = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _generateTicket,
                    child: Text('Generar Entrada'),
                  ),
                ],
              ),
            ),
    );
  }
}
