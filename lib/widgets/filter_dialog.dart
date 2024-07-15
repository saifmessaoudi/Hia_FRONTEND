import 'package:flutter/material.dart';
import 'package:hia/constant.dart';
import 'package:hia/views/global_components/button_global.dart';

class FilterDialog extends StatefulWidget {
  final Function(List<String>) onApply;

  const FilterDialog({super.key, required this.onApply});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<String> selectedFilters = [];

  final List<Map<String, String>> filters = [
    {"name": "Restaurant", "image": "images/restaurant.png"},
    {"name": "Fast Food", "image": "images/fastfood.jpg"},
    {"name": "Vegetarian", "image": "images/vegan.jpg"},
    // Add more filters as needed
  ];

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
            height: constraints.maxHeight * 0.5,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
             
                const SizedBox(height: 10.0),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: filters.length,
                    itemBuilder: (context, index) {
                      String filterName = filters[index]['name']!;
                      String filterImage = filters[index]['image']!;
                      bool isSelected = selectedFilters.contains(filterName);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedFilters.remove(filterName);
                            } else {
                              selectedFilters.add(filterName);
                            }
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: isSelected ? kMainColor.withOpacity(0.3) : Colors.white,
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10.0),
                                  ),
                                  child: Image.asset(
                                    filterImage,
                                    height: 60,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      filterName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel' , style: TextStyle(color: Colors.red),),
                    ),
                   TextButton(
                      onPressed: () {
                        widget.onApply(selectedFilters);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Apply', style: TextStyle(color: kMainColor),),
                   )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
