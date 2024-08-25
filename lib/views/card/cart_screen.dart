import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/viewmodels/cart_viewmodel.dart';
import 'package:hia/views/card/empty_card.dart';
import 'package:hia/views/card/loading_order.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:hia/widgets/cart_item_widget.dart';
import 'package:hia/widgets/custom_toast.dart';
import 'package:hia/widgets/shimmer_cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Scaffold(
            body: Column(
              children: [
                const SizedBox(height: 30.0),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return const ShimmerCartItem();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        var cart = viewModel.cart!;
        if (cart.items.isEmpty) {
          return const EmptyCard();
        }

        Debugger.green(viewModel.cart?.establishmentId);
        return SmartScaffold(
          bottomNavigationBar: Card(
            elevation: 1.0,
            color: const Color(0xFFF5F5F5),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Total: ${viewModel.getTotalPrice()} TND',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showLoadingScreen(context);
                      },
                      child: Container(
                        height: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: kMainColor,
                        ),
                        child: Center(
                          child: Text(
                            'Place Order',
                            style: kTextStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
              Column(
                children: [
                  const SizedBox(height: 50.0),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        color: Colors.white,
                      ),
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          var item = cart.items[index];
                          var key = item.food?.id ?? item.offer?.id ?? '';
                          var name = item.food?.name ?? item.offer?.name ?? '';
                          var imageUrl = item.food?.image ?? item.offer?.image ?? '';
                          var price = item.food?.price ?? item.offer?.price ?? 0.0;

                          return Dismissible(
                            key: Key(key),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.transparent,
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(Icons.delete, color: Colors.red, size: 30.0),
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              if (item.food != null) {
                                viewModel.removeItem(item.food!);
                                showCustomToast(context, "${item.food!.name} removed from cart");
                              } else if (item.offer != null) {
                                viewModel.removeItem(null, offer: item.offer);
                                showCustomToast(context, "${item.offer!.name} removed from cart");
                              }
                            },
                            child: CartItemWidget(
                              imageUrl: imageUrl,
                              name: name,
                              price: price.toDouble(),
                              quantity: item.quantity,
                              onIncrease: () {
                                if (item.food != null) {
                                  viewModel.updateItemQuantity(item.food!, item.quantity + 1);
                                } else if (item.offer != null) {
                                  viewModel.updateItemQuantity(null, item.quantity + 1, offer: item.offer!);
                                }
                              },
                              onDecrease: () {
                                if (item.food != null) {
                                  viewModel.updateItemQuantity(item.food!, item.quantity - 1);
                                } else if (item.offer != null) {
                                  viewModel.updateItemQuantity(null, item.quantity - 1, offer: item.offer!);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

void _showLoadingScreen(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const LoadingScreenDialog(),
  );
}