import 'package:flutter/material.dart';
import 'package:rick_and_morty/l10n/app_localizations.dart';
import 'package:rick_and_morty/pages/character_details_page.dart';
import 'package:rick_and_morty/services/rickandmorty_service.dart';
import 'package:rick_and_morty/util/string_utils.dart';
import 'package:rick_and_morty/view_models/character_details_viewmodel.dart';

import '../services/di.dart';
import '../ui/http_image.dart';
import '../view_models/characters/character_item_viewmodel.dart';
import '../view_models/characters_viewmodel.dart';
import 'package:http/http.dart' as http;

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key, required this.viewModel, required this._httpClient});

  final http.Client _httpClient;
  final CharactersViewModel viewModel;

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
    final appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.characters)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, _) => SearchBar(
                controller: _searchController,
                hintText: appLocalizations.searchByName,
                leading: const Icon(Icons.search),
                textInputAction: TextInputAction.search,
                onChanged: _vm.onQueryChanged,
                trailing: [
                  if (value.text.isNotEmpty)
                    IconButton(
                      tooltip: appLocalizations.clearSearch,
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
    final appLocalizations = AppLocalizations.of(context)!;

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
          title: appLocalizations.couldNotLoadCharacters,
          detail: error,
          actionLabel: appLocalizations.tryAgain,
          onAction: () => _vm.loadCommand.execute(),
        );
      }
      final query = _vm.query;
      final searching = query != null && query.isNotEmpty;
      return _Message(
        icon: Icons.search_off,
        title: searching ? appLocalizations.noResultsFor(query) : appLocalizations.noCharactersYet,
        detail: searching ? appLocalizations.tryDifferentName : null,
      );
    }

    final hasFooter = _vm.loading || error != null;
    return GridView.builder(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,       // Two cards in a row
        crossAxisSpacing: 16,    // Space between columns
        mainAxisSpacing: 16,     // Space between rows
        // Note: Standard GridView requires a childAspectRatio.
        // If your text is short, 0.7 to 0.75 usually fits a square + 2 lines of text.
        childAspectRatio: 0.72,
      ),
      itemCount: items.length + (hasFooter ? 1 : 0),
      itemBuilder: (context, i) {
        if (i < items.length) {
          final item = items[i];
          return _CharacterTile(
            item,
            client: widget._httpClient,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CharacterDetailsPage(
                  viewModel: CharacterDetailsViewModel(
                    service: DI.resolveOrCrash<IRickAndMortyService>(),
                    id: item.id,
                  ), httpClient: DI.resolveOrCrash<http.Client>(),
                ),
              ),
            )
          );
        }
        return Center(
          child: _vm.loading
              ? const CircularProgressIndicator()
              : TextButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: Text(appLocalizations.couldNotLoadMore(error ?? "")),
                  onPressed: _vm.retry,
                ),
        );
      },
    );
  }
}

class _CharacterTile extends StatelessWidget {
  const _CharacterTile(this.item, {required this.client, this.onTap});

  final CharacterItemViewModel item;
  final http.Client client;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell( // Wrap in InkWell here if you want the whole card clickable
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Fixed Square Image
            AspectRatio(
              aspectRatio: 1.0,
              child: Image(
                image: ResizeImage.resizeIfNeeded(300, 300, HttpImage(Uri.parse(item.userPic), client: client)),
                fit: BoxFit.contain,
                frameBuilder: (context, child, frame, sync) => frame == null && !sync
                    ? const Center(
                  child: SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                    : child,
                errorBuilder: (context, error, stack) => const Center(
                  child: Icon(Icons.broken_image_outlined),
                ),
              ),
            ),

            // 2. Text Container (Expanded removed, replaced with a safe scrolling context)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Wrap tightly around content lines
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2), // Slightly tightened spacing
                  Text(
                    item.status.localize(localization) ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1, // Restrict to 1 line to ensure it fits perfectly within 0.72 aspect ratio
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
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
                child: Text(actionLabel ?? AppLocalizations.of(context)!.tryAgain),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
