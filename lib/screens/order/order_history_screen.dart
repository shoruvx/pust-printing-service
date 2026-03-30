import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_bloc.dart'; // Import your BLoC for orders

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: OrderSearchDelegate());
            },
          ),
        ],
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            final orders = state.orders;
            return Column(
              children: [
                _buildFilterSortOptions(context),
                Expanded(
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Order #${orders[index].id}'),
                        subtitle: Text('Date: ${orders[index].date}'),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Failed to load orders.'));
          }
        },
      ),
    );
  }

  Widget _buildFilterSortOptions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<String>(
            items: <String>['Date', 'Status'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Call your filter function here
            },
            hint: Text('Sort by'),
          ),
        ),
      ],
    );
  }
}

class OrderSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results
    return Container(); // Replace with search result display
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Provide suggestions based on query
    return Container(); // Replace with suggestions logic
  }
}
