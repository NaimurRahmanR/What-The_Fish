import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/fish_provider.dart';
import '../models/fish_identification.dart';
import '../utils/theme.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _sortBy = 'date';
  double _minConfidence = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.oceanGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fish History',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: _showFilterDialog,
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),

              // History List
              Expanded(
                child: Consumer<FishProvider>(
                  builder: (context, fishProvider, child) {
                    final identifications = _getFilteredIdentifications(
                      fishProvider.identifications,
                    );

                    if (identifications.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pets,
                              size: 80,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'No fish identified yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Start identifying fish by using the camera!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: identifications.length,
                      itemBuilder: (context, index) {
                        final identification = identifications[index];
                        return _buildHistoryItem(context, identification);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, FishIdentification identification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            blurRadius: 15,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            File(identification.imagePath),
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              );
            },
          ),
        ),
        title: Text(
          identification.speciesName,
          style: const TextStyle(
            style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.darkBlue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              identification.scientificName,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor(identification.confidence),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${(identification.confidence * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: identification.isEdible ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    identification.isEdible ? '🍽️ EDIBLE' : '⚠️ TOXIC',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  DateFormat('MMM d, y').format(identification.identifiedAt),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              _confirmDelete(context, identification);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(identification: identification),
            ),
          );
        },
      ),
    );
  }

  List<FishIdentification> _getFilteredIdentifications(
    List<FishIdentification> identifications,
  ) {
    var filtered = identifications
        .where((item) => item.confidence >= _minConfidence)
        .toList();

    switch (_sortBy) {
      case 'date':
        filtered.sort((a, b) => b.identifiedAt.compareTo(a.identifiedAt));
        break;
      case 'confidence':
        filtered.sort((a, b) => b.confidence.compareTo(a.confidence));
        break;
      case 'name':
        filtered.sort((a, b) => a.speciesName.compareTo(b.speciesName));
        break;
    }

    return filtered;
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter & Sort'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sort by:'),
                  RadioListTile<String>(
                    title: const Text('Date'),
                    value: 'date',
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setDialogState(() {
                        _sortBy = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Confidence'),
                    value: 'confidence',
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setDialogState(() {
                        _sortBy = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Name'),
                    value: 'name',
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setDialogState(() {
                        _sortBy = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Minimum Confidence: ${(_minConfidence * 100).toStringAsFixed(0)}%'),
                  Slider(
                    value: _minConfidence,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    onChanged: (value) {
                      setDialogState(() {
                        _minConfidence = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, FishIdentification identification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Identification'),
          content: Text(
            'Are you sure you want to delete the identification for "${identification.speciesName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<FishProvider>().deleteIdentification(identification.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Identification deleted')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

