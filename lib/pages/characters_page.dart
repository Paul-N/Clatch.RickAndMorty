import 'package:flutter/material.dart';

import '../view_models/characters/character_item_viewmodel.dart';
import '../view_models/characters_viewmodel.dart';

/// Searchable, infinitely scrolling list of characters (Material 3).
///
/// All state and logic live in [CharactersViewModel]; this widget only renders
/// it and forwards user input. The caller owns (and disposes) the view model.
class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key, required this.viewModel, this.onSelected});

  final CharactersViewModel viewModel;
  final ValueChanged<CharacterItemViewModel>? onSelected;

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final _scroll = ScrollController();
  final _searchController = TextEditingController();

  CharactersViewModel get _vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _vm.loadCommand.execute();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.extentAfter < 400) _vm.loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, _) => SearchBar(
                controller: _searchController,
                hintText: 'Search by name',
                leading: const Icon(Icons.search),
                textInputAction: TextInputAction.search,
                onChanged: _vm.onQueryChanged,
                trailing: [
                  if (value.text.isNotEmpty)
                    IconButton(
                      tooltip: 'Clear search',
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        _vm.onQueryChanged('');
                      },
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: _vm,
              builder: (context, _) => _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final items = _vm.characters;
    final error = _vm.error;
    final notFoundMessage = _vm.notFoundMessage;

    if (items.isEmpty) {
      if (_vm.loading) return const Center(child: CircularProgressIndicator());
      if(notFoundMessage != null) {
        return _Message(
          icon: Icons.search_off,
          title: notFoundMessage,
        );
      }
      if (error != null) {
        return _Message(
          icon: Icons.cloud_off,
          title: 'Couldn’t load characters',
          detail: error,
          actionLabel: 'Try again',
          onAction: () => _vm.loadCommand.execute(),
        );
      }
      final query = _vm.query;
      final searching = query != null && query.isNotEmpty;
      return _Message(
        icon: Icons.search_off,
        title: searching ? 'No results for “$query”' : 'No characters yet',
        detail: searching ? 'Try a different name.' : null,
      );
    }

    final hasFooter = _vm.loading || error != null;
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: items.length + (hasFooter ? 1 : 0),
      itemBuilder: (context, i) {
        if (i < items.length) {
          final item = items[i];
          final onSelected = widget.onSelected;
          return _CharacterTile(
            item,
            onTap: onSelected == null ? null : () => onSelected(item),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: _vm.loading
                ? const CircularProgressIndicator()
                : TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Couldn’t load more. Retry'),
              onPressed: _vm.retry,
            ),
          ),
        );
      },
    );
  }
}

class _CharacterTile extends StatelessWidget {
  const _CharacterTile(this.item, {this.onTap});

  final CharacterItemViewModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        // ASSUMPTION: CharacterItemViewModel exposes name, image and subtitle.
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.userPic.toString()),
        ),
        title: Text(item.name),
        subtitle: Text(item.status),
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