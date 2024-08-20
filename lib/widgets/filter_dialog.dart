import 'package:flutter/material.dart';
import 'package:hia/constant.dart';

class FilterDialog extends StatefulWidget {
  final Function(List<String>) onApply;
  final List<String> initialSelectedFilters;

  const FilterDialog({super.key, required this.onApply, required this.initialSelectedFilters});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late List<String> selectedFilters;

  final List<Map<String, String>> filters = [
    {"name": "Restaurant", "image": "images/fastfood.png"},
    {"name": "Boulangerie", "image": "images/sugar.png"},
    {"name": "Sortie", "image": "images/fastfood.png"},
  ];

  @override
  void initState() {
    super.initState();
    selectedFilters = List<String>.from(widget.initialSelectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth * 0.8,
            height: constraints.maxHeight * 0.19,
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: filters.map((filter) {
                    String filterName = filter['name']!;
                    String filterImage = filter['image']!;
                    bool isSelected = selectedFilters.contains(filterName);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedFilters.remove(filterName);
                          } else {
                            selectedFilters.add(filterName);
                          }
                          widget.onApply(selectedFilters);
                        });
                      },
                      child:                       ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Stack(
                          children: [
                            Image.asset(
                              filterImage,
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: isSelected ? kMainColor.withOpacity(0.5) : Colors.transparent,
                              ),
                            ),
                            // Gradient Overlay at the bottom of the image
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 25, // Adjust gradient height as needed
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              left: 5,
                              right: 5,
                              child: Text(
                                filterName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          );
        },
      ),
    );
  }
}