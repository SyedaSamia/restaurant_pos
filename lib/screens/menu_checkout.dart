import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/providers/checkout_provider.dart';
import 'package:restaurantpos/screens/home.page.dart';
import 'package:restaurantpos/screens/item_screen.dart';
import 'package:restaurantpos/utils/size_config.dart';
import 'package:restaurantpos/widgets/cart_item.dart';
import 'package:restaurantpos/widgets/main_drawer.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Checkout extends StatelessWidget {
  /*final _items;
  final _totals;
  Checkout(this._items, this._totals);*/
  static const routeName = '/checkout';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    var iNameList = [];
    var iQuantityList = [];
    var iPriceList = [];

    /* Builder _floatingActionButton() {
      return Builder(
          builder: (context) => );
    }*/

    final _floatingActionButton = FloatingActionButton.extended(
      label: Text(
        'Print Pdf',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      icon: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
      ),
      onPressed: () {
        /*_scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Order Added!'),
          duration: Duration(seconds: 3),
        ));*/
        if (cart.totalAmount != 0) {
          Provider.of<CheckoutProvider>(context, listen: false)
              .addCheckoutOrder(
                  cart.items.values.toList(), cart.totalAmount, cart.totalVat);
          for (int i = 0; i < cart.items.length; i++) {
            iNameList.add(cart.items.values.toList()[i].title);
            iPriceList.add(cart.items.values.toList()[i].price);
            iQuantityList.add(cart.items.values.toList()[i].quantity);
          }
          Fluttertoast.showToast(
                  msg: "Checkout Complete!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blueGrey,
                  textColor: Colors.white,
                  fontSize: 16.0)
              .then((value) => sleep(Duration(seconds: 1)))
              .then((value) => _createPDF(cart.items.length, iNameList,
                  iPriceList, iQuantityList, cart.totalVat, cart.totalAmount))
              .then((value) {
            cart.clear();
            Fluttertoast.cancel();
            Navigator.of(context).pop(true);
            Fluttertoast.cancel();
          });
        }
      },
      backgroundColor: Theme.of(context).primaryColor,
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(true);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Checkout'),
          ),
          drawer: MainDrawer(),
          body: ListView.builder(
            itemCount: cart.items.length + 1,
            itemBuilder: (ctx, i) => i > cart.items.length - 1
                ? Container(
                    width: SizeConfig.blockSizeHorizontal * 70,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 70,
                            height: SizeConfig.blockSizeVertical * 5,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Vat (15%)'),
                                  Text('\$${cart.totalVat}'),
                                ]),
                          ),
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 70,
                            height: SizeConfig.blockSizeVertical * 5,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Total'),
                                  Text('\$${cart.totalAmount}'),
                                ]),
                          ),
                        ]))
                : CartItem(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity,
                    cart.items.values.toList()[i].title,
                  ),

            /*Consumer<CheckoutProvider>(
            builder: (ctx, orderData, child) => ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, i) => CheckoutOrderItem(orderData.orders[i]),
            ),
          ),*/

            /*FutureBuilder(
          future: Provider.of<CheckoutProvider>(context, listen: false)
              .fetchAndSetCheckoutOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                // ...
                // Do error handling stuff
                return Center(
                  child: Text('An error occurred! ${dataSnapshot.error}'),
                );
              } else {
                return Consumer<CheckoutProvider>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) =>
                        CheckoutOrderItem(orderData.orders[i]),
                  ),
                );
              }
            }
          },
        ),*/
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _floatingActionButton),
    );
  }

  Future<void> _createPDF(_length, _itemNameList, _itemPriceList,
      _itemQuantityList, _totalVat, _totalAmount) async {
    //Create a PDF document.
    PdfDocument document = PdfDocument();

    //Create a border
    PdfBorders border = PdfBorders(
/*        left: PdfPen(PdfColor(240, 0, 0), width: 2),
        top: PdfPen(PdfColor(0, 240, 0), width: 3),
        bottom: PdfPen(PdfColor(0, 0, 240), width: 4),
        right: PdfPen(PdfColor(240, 100, 240), width: 5)
    */
        left: PdfPen(PdfColor(240, 240, 240), width: 2),
        top: PdfPen(PdfColor(240, 240, 240), width: 3),
        bottom: PdfPen(PdfColor(240, 240, 240), width: 4),
        right: PdfPen(PdfColor(240, 240, 240), width: 5));

    PdfStringFormat format = PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.bottom,
        wordSpacing: 10);

    PdfGridCellStyle cellStyle = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.white,
      borders: border,
      cellPadding: PdfPaddings(left: 1, right: 1, top: 1, bottom: 1),
      font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
      format: format,
      textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );

    //Create a grid style
    PdfGridStyle gridStyle = PdfGridStyle(
      cellSpacing: 2,
      cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
      borderOverlapStyle: PdfBorderOverlapStyle.inside,
      backgroundBrush: PdfBrushes.white,
      textPen: PdfPens.black,
      textBrush: PdfBrushes.white,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
    );
    final PdfPage page = document.pages.add();
    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 5);
    //grid.headers.add(1);

    PdfGridRow header = grid.headers.add(1)[0];
    header.cells[0].value = 'No';
    header.cells[1].value = 'Item Name';
    header.cells[2].value = 'Quantity';
    header.cells[3].value = 'Price';
    header.cells[4].value = 'Total';

    //Add page and draw text to the page.
    /* document.pages.add().graphics.drawString(
        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 18),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, 0, 500, 30));*/

    // PdfGridRow totalAmount = grid.rows.add();

    // PdfGridRow totalVat = grid.rows.add();
    /* totalAmount.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.dimGray,
        textPen: PdfPens.lightGoldenrodYellow,
        textBrush: PdfBrushes.darkOrange,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12));*/

    //Apply the grid style
    grid.rows.applyStyle(gridStyle);

    PdfGridRow row;

    for (int i = 0; i <= _length + 1; i++) {
      row = grid.rows.add();
      if (i < _length) {
        row.cells[0].value = '${i + 1}';
        row.cells[1].value = '${_itemNameList[i]}';
        row.cells[2].value = '${_itemQuantityList[i]}';
        row.cells[3].value = '${_itemPriceList[i]}';
        row.cells[4].value = '${_itemQuantityList[i] * _itemPriceList[i]}';
      } else if (i == _length) {
        row.cells[0].value = 'Vat(15%)';
        row.cells[1].value = '';
        row.cells[2].value = '';
        row.cells[3].value = '';
        row.cells[4].value = '$_totalVat';
      } else {
        row.cells[0].value = 'Total Amount';
        //  row.cells[1].value = '';
        row.cells[2].value = '';
        //  row.cells[3].value = '';
        row.cells[4].value = '$_totalAmount';
      }
    }
    for (int i = 0; i < 5; i++) {
      row.cells[i].style = cellStyle;
    }
    var num = Random().nextInt(1000);
    //Set the grid style
    /* grid.style = PdfGridStyle(
       // cellSpacing: 2,
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
        backgroundBrush: PdfBrushes.white,
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 17));
    var _bounds = const Rect.fromLTWH(0, 0, 0, 0);
    grid.draw(page: page, bounds: _bounds);*/

    /*page.graphics.drawString('Total Amount: \$' + totalAmount.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, page.getClientSize().width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));*/
    grid.draw(page: page, bounds: const Rect.fromLTWH(0, 0, 0, 0));
    //Save the document
    var bytes = document.save();
    // Dispose the document
    document.dispose();
    //Get external storage directory
    Directory directory = await getExternalStorageDirectory();
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/$num.pdf');
    //Write PDF data
    await file.writeAsBytes(bytes, flush: true);
//Open the PDF document in mobile
    OpenFile.open('$path/$num.pdf');
  }
}
