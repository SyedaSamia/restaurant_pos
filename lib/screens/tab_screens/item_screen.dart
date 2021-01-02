import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:restaurantpos/providers/items_provider.dart';
import 'package:restaurantpos/widgets/item/item.dart';

class ItemScreen extends StatefulWidget {
  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<ItemsProvider>(context).fetchAndSetItems().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final itemsData = Provider.of<ItemsProvider>(context);
    final items = itemsData.items;

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          )
        : Container(
            padding: EdgeInsets.only(top: 15),
            child: ListView.separated(
              itemCount: items.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: items[i],
                child: Item(i),
              ),
              separatorBuilder: (context, index) => Divider(),
            ),
          );
  }
}
