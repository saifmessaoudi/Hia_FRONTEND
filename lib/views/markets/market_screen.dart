import 'package:flutter/material.dart';
import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:hia/viewmodels/market_viewmodel.dart';

import 'package:hia/views/home/establishment_search_delegate.dart';
import 'package:hia/views/markets/marget_grid_list.dart';

import 'package:provider/provider.dart';

import '../../constant.dart';

class MarketsScreen extends StatefulWidget {
  const MarketsScreen({Key? key}) : super(key: key);

  @override
  _MarketsScreenState createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {

  @override
  Widget build(BuildContext context) {
      
//Provider.of<MarketViewModel>(context).fetchMarkets();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/hiaauthbgg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                     const  Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )
                      ),
                      Text(
                        'Markets',
                        style: kTextStyle.copyWith(
                            color: Colors.white, fontSize: 18.0),
                      ),
                       const SizedBox(width: 180,),
            IconButton(
              icon: const Icon(Icons.search,color: Colors.white,),
              onPressed: () async {
                final selected = await showSearch(
                  context: context,
                  delegate: EstablishmentSearchDelegate(Provider.of<EstablishmentViewModel>(context, listen: false),), // Replace with your custom SearchDelegate
                );
                // Handle search results if needed
              },
            ),
        
                    ],
                  ),
                  const SizedBox(
                    
                    height: 30.0,
                  ),
            Padding(
  padding: const EdgeInsets.all(0.0),
  child: Consumer<MarketViewModel>(
    builder: (context, marketViewModel, child) {
      return MarketGrid();
    },
  ),
)




                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
