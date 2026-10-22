import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../view_models/character_details_viewmodel.dart';

class CharacterDetailsPage extends StatefulWidget {
  const CharacterDetailsPage({
    super.key,
    required this.viewModel,
    required this._httpClient,
  });

  final http.Client _httpClient;
  final CharacterDetailsViewModel viewModel;

  @override
  State<CharacterDetailsPage> createState() => _CharacterDetailsPageState();
}

class _CharacterDetailsPageState extends State<CharacterDetailsPage> {
  final _scroll = ScrollController();
  final _searchController = TextEditingController();

  CharacterDetailsViewModel get _vm => widget.viewModel;

  @override
  void initState() {
    super.initState();

    _vm.loadCommand.execute();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _searchController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Characters ${_vm.id}')));
  }
}
