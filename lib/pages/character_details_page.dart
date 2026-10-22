import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty/dto/character.dart';
import 'package:rick_and_morty/util/string_utils.dart';

import '../l10n/app_localizations.dart';
import '../ui/http_image.dart';
import '../view_models/character_details_viewmodel.dart';

class CharacterDetailsPage extends StatefulWidget {
  const CharacterDetailsPage({
    super.key,
    required this.viewModel,
    required this.httpClient,
  });

  final http.Client httpClient;
  final CharacterDetailsViewModel viewModel;

  @override
  State<CharacterDetailsPage> createState() => _CharacterDetailsPageState();
}

class _CharacterDetailsPageState extends State<CharacterDetailsPage> {
  CharacterDetailsViewModel get _vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _vm.loadCommand.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${AppLocalizations.of(context)!.character} #${_vm.id}')),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) => _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (_vm.loading && _vm.name == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_vm.error case final error?) {
      return _Message(
        icon: Icons.cloud_off,
        title: localizations.couldNotLoadCharacter,
        detail: error,
        onRetry: () => _vm.loadCommand.execute(),
      );
    }

    if (_vm.notFoundMessage case final message?) {
      return _Message(
        icon: Icons.person_search_outlined,
        title: localizations.characterNotFound,
        detail: message,
        onRetry: () => _vm.loadCommand.execute(),
      );
    }

    if (_vm.name case final name?) {
      return _Profile(
        name: name,
        image: _vm.userPic,
        status: _vm.status?.localize(localizations),
        species: _vm.species,
        origin: _vm.origin,
        location: _vm.location,
        client: widget.httpClient,
      );
    }

    return _Message(
      icon: Icons.person_outline,
      title: localizations.characterDetailsUnavailable,
      onRetry: () => _vm.loadCommand.execute(),
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile({
    required this.name,
    required this.image,
    required this.status,
    required this.species,
    required this.origin,
    required this.location,
    required this.client,
  });

  final String name;
  final Uri? image;
  final String? status;
  final String? species;
  final String? origin;
  final String? location;
  final http.Client client;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appLocalizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: image == null
                      ? ColoredBox(
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.person_outline,
                            size: 88,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                      : Image(
                          image: ResizeImage.resizeIfNeeded(
                            900,
                            900,
                            HttpImage(image!, client: client),
                          ),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              ColoredBox(
                                color: colorScheme.surfaceContainerHighest,
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 64,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                name,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (status != null || species != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (status case final value?)
                      _InfoChip(
                        icon: Icons.circle,
                        label: _displayValue(value),
                      ),
                    if (species case final value?)
                      _InfoChip(icon: Icons.biotech_outlined, label: value),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    if (origin case final value?)
                      _DetailRow(
                        icon: Icons.public,
                        label: appLocalizations.origin,
                        value: value,
                      ),
                    if (origin != null && location != null)
                      const Divider(height: 1, indent: 56),
                    if (location case final value?)
                      _DetailRow(
                        icon: Icons.location_on_outlined,
                        label: appLocalizations.lastKnownLocation,
                        value: value,
                      ),
                    if (origin == null && location == null)
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(appLocalizations.noLocationDetailsAvailable),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _displayValue(String value) {
    final label = value.split('.').last;
    return label.isEmpty
        ? label
        : '${label[0].toUpperCase()}${label.substring(1)}';
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 16), label: Text(label));
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    this.detail,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String? detail;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (detail != null) ...[
              const SizedBox(height: 8),
              Text(
                detail!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onRetry,
                child: Text(AppLocalizations.of(context)!.tryAgain),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
