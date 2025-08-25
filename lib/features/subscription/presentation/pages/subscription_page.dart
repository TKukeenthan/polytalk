import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';
import '../bloc/subscription_state.dart';

class SubscriptionPage extends StatefulWidget {
const SubscriptionPage({super.key});

@override
_SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
List<Package> _packages = [];

@override
void initState() {
super.initState();
_loadOfferings();
}

Future<void> _loadOfferings() async {
try {
final offerings = await Purchases.getOfferings();
if (offerings.current != null) {
setState(() {
_packages = offerings.current!.availablePackages;
});
}
} catch (e) {
// Handle error
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Go Pro'),
),
body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
listener: (context, state) {
if (state is SubscriptionActive) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('Purchase successful!')),
);
Navigator.pop(context);
} else if (state is SubscriptionError) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text('Error: ${state.message}')),
);
}
},
builder: (context, state) {
if (state is SubscriptionLoading) {
return const Center(child: CircularProgressIndicator());
}


    
if (_packages.isEmpty) {
        return const Center(child: Text('No subscription plans available.'));
      }

      return ListView.builder(
        itemCount: _packages.length,
        itemBuilder: (context, index) {
          final package = _packages[index];
          return Card(
            margin: const EdgeInsets.all(16),
            child: ListTile(
              title: Text(package.storeProduct.title),
              subtitle: Text(package.storeProduct.description),
              trailing: Text(package.storeProduct.priceString),
              onTap: () {
                context.read<SubscriptionBloc>().add(PurchasePackageEvent(package));
              },
            ),
          );
        },
      );
    },
  ),
);

  

}
}