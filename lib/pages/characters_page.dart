import 'dart:async';

import 'package:flutter/material.dart';
// Adjust these imports to your project layout (and add wherever
// CharacterFilter lives).
import 'package:rick_and_morty/rest_api/rm_rest_api.dart'; // IRickAndMortyRestApi
import 'package:rick_and_morty/dto/character.dart';
import 'package:rick_and_morty/dto/paged_response.dart';

/// Searchable, infinitely scrolling list of characters (Material 3).
///
/// The search text is sent to the API as a name filter (debounced), and the
/// next page is requested through `info.next` when the user nears the end.
class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key, required this.api, this.onSelected});

  final IRickAndMortyRestApi api;
  final ValueChanged<Character>? onSelected;

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final _scroll = ScrollController();
  final _searchController = TextEditingController();
  final _items = <Character>[];

  Timer? _debounce;
  Uri? _next;
  String _query = '';
  String? _error;
  bool _loading = false;

  /// Bumped on every new search so responses to old searches are dropped.
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _fetch(firstPage: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scroll.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.extentAfter < 400) _fetch(firstPage: false);
  }

  void _onQueryChanged(String value) {
    setState(() {}); // refreshes the clear button
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final q = value.trim();
      if (q == _query) return;
      _query = q;
      _fetch(firstPage: true);
    });
  }

  Future<void> _fetch({required bool firstPage}) async {
    if (!firstPage && (_loading || _next == null || _error != null)) return;

    final generation = firstPage ? ++_generation : _generation;
    setState(() {
      _loading = true;
      _error = null;
      if (firstPage) {
        _items.clear();
        _next = null;
      }
    });

    final result = firstPage
        ? await widget.api.getCharacters(
      // ASSUMPTION: CharacterFilter has a `name` parameter.
      filter: _query.isEmpty ? null : CharacterFilter(name: _query),
    )
        : await widget.api.getCharactersByUri(_next!);

    if (!mounted || generation != _generation) return;
    setState(() {
      _loading = false;
      result.split(
            (page) {
          _items.addAll(page.results); // ASSUMPTION: PagedResponse.results
          _next = _nextOf(page);
        },
            (problem) {
          _error = problem.title ?? 'The server rejected the request.';
        },
            (_) {
          _error = 'Check your connection and try again.';
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search by name',
              leading: const Icon(Icons.search),
              textInputAction: TextInputAction.search,
              onChanged: _onQueryChanged,
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    tooltip: 'Clear search',
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      _onQueryChanged('');
                    },
                  ),
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_items.isEmpty) {
      if (_loading) return const Center(child: CircularProgressIndicator());
      if (_error != null) {
        return _Message(
          icon: Icons.cloud_off,
          title: 'Couldn’t load characters',
          detail: _error,
          actionLabel: 'Try again',
          onAction: () => _fetch(firstPage: true),
        );
      }
      return _Message(
        icon: Icons.search_off,
        title: _query.isEmpty ? 'No characters yet' : 'No results for “$_query”',
        detail: _query.isEmpty ? null : 'Try a different name.',
      );
    }

    final hasFooter = _loading || _error != null;
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: _items.length + (hasFooter ? 1 : 0),
      itemBuilder: (context, i) {
        if (i < _items.length) {
          final character = _items[i];
          final onSelected = widget.onSelected;
          return _CharacterTile(
            character,
            onTap: onSelected == null ? null : () => onSelected(character),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: _loading
                ? const CircularProgressIndicator()
                : TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Couldn’t load more. Retry'),
              onPressed: () {
                setState(() => _error = null);
                _fetch(firstPage: false);
              },
            ),
          ),
        );
      },
    );
  }
}

class _CharacterTile extends StatelessWidget {
  const _CharacterTile(this.character, {this.onTap});

  final Character character;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        // ASSUMPTION: Character has name, status, species and image.
        leading: CircleAvatar(
          backgroundImage: NetworkImage(character.image.toString()),
        ),
        title: Text(character.name),
        subtitle: Text('${_label(character.status)}, ${character.species}'),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    this.detail,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? detail;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: muted),
            const SizedBox(height: 16),
            Text(title,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center),
            if (detail != null) ...[
              const SizedBox(height: 4),
              Text(detail!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: muted),
                  textAlign: TextAlign.center),
            ],
            if (onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onAction,
                child: Text(actionLabel ?? 'Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ASSUMPTION: `info.next` is a Uri? or String? (works for both).
Uri? _nextOf(PagedResponse<Character> page) {
  final next = page.info?.next?.toString();
  return next == null ? null : Uri.tryParse(next);
}

/// Works whether the field is an enum or a plain String.
String _label(Object? value) {
  final s = switch (value) {
    null => '',
    Enum e => e.name,
    _ => '$value',
  };
  return s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}