import 'package:hia/app/style/widget_modifier.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/viewmodels/cart_viewmodel.dart';
import 'package:hia/views/card/empty_card.dart';
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

        return SmartScaffold(
          bottomNavigationBar: Card(
            elevation: 0.0,
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
                        ).onTap(() {
                          Debugger.green('Checkout Button Pressed');
                        }),
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
                          return Dismissible(
                            key: Key(item.food.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.transparent,
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(Icons.delete, color: Colors.red, size: 30.0),
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              viewModel.removeItem(item.food);
                             showCustomToast(context, "${item.food.name} removed from cart");
                            },
                            child: CartItemWidget(
                              imageUrl: item.food.image,
                              name: item.food.name,
                              price: item.food.price,
                              quantity: item.quantity,
                              onIncrease: () {
                                viewModel.updateItemQuantity(item.food, item.quantity + 1);
                              },
                              onDecrease: () {
                                viewModel.updateItemQuantity(item.food, item.quantity - 1);
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
