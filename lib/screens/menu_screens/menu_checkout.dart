import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:restaurantpos/providers/auth.dart';
import 'package:restaurantpos/providers/categories_provider.dart';
import 'package:restaurantpos/providers/checkout_provider.dart';
import 'package:restaurantpos/providers/order_staging_provider.dart';
import 'package:restaurantpos/utils/size_config.dart';
import 'package:restaurantpos/widgets/checkout/checkout_item.dart';
import 'package:restaurantpos/widgets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../home.page.dart';
import 'order_staging_screen.dart';

class Checkout extends StatelessWidget {
  static const routeName = '/checkout';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<OrderStagingProvider>(context);

    var iNameList = [];
    var iQuantityList = [];
    var iPriceList = [];

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
        if (cart.totalCheckoutAmount != 0) {
          Provider.of<CheckoutProvider>(context, listen: false)
              .addCheckoutOrder(cart.currentOrderId, cart.totalAmountToPrint,
                  cart.totalCheckoutVat, cart.currentDiscountToPrint);
          for (int i = 0; i < cart.checkoutItem.length; i++) {
            iNameList.add(cart.checkoutItem[i].title);
            iPriceList.add(cart.checkoutItem[i].price);
            iQuantityList.add(cart.checkoutItem[i].quantity);
          }

          Fluttertoast.showToast(
                  msg: "Checkout Complete!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blueGrey,
                  textColor: Colors.white,
                  fontSize: 16.0)
              .then((value) =>
                  /*sleep(Duration(seconds: 1)))
              .then((value) =>*/
                  _createPDF(
                      cart.checkoutItem.length,
                      iNameList,
                      iPriceList,
                      iQuantityList,
                      cart.totalCheckoutVat,
                      cart.currentDiscountToPrint,
                      cart.totalCheckoutAmount,
                      cart.customerName,
                      cart.customerPhone,
                      cart.remarks))
              .then((value) {
            cart.clear();
            Fluttertoast.cancel();
            Provider.of<CheckoutProvider>(context, listen: false).fetchOrders();
            Navigator.of(context).pushReplacementNamed(HomePage.routeName);
            // Navigator.of(context).pop(true);
            Fluttertoast.cancel();
          });
        }
      },
      backgroundColor: Theme.of(context).primaryColor,
    );

    return WillPopScope(
      onWillPop: () {
        // Navigator.of(context).pop(true);
        return Navigator.of(context)
            .pushReplacementNamed(OrderStaging.routeName);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Checkout'),
            actions: <Widget>[
              BackButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(OrderStaging.routeName);
                },
              )
            ],
          ),
          drawer: MainDrawer(),
          body: cart.totalCheckoutAmount > 0
              ? ListView.builder(
                  itemCount: cart.currentCheckoutItemsCount + 1,
                  itemBuilder: (ctx, i) => i < cart.currentCheckoutItemsCount
                      ? CheckoutItem(
                          cart.checkoutItem[i].itemId,
                          cart.checkoutItem[i].price,
                          cart.checkoutItem[i].quantity,
                          cart.checkoutItem[i].title,
                        )
                      : Container(
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
                                        Text('\$${cart.totalCheckoutVat}'),
                                      ]),
                                ),
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 70,
                                  height: SizeConfig.blockSizeVertical * 5,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Discount'),
                                        Text(
                                            '\$${cart.currentDiscountToPrint}'),
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
                                        Text('\$${cart.totalAmountToPrint}'),
                                      ]),
                                ),
                              ])),
                )
              : Container(
                  height: 50,
                  child: Center(
                      child: Container(
                          height: 15, child: Text('Empty Checkout')))),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _floatingActionButton),
    );
  }

  /*Future<File> _getImageLogoFile() async {
    var bytes = await rootBundle.load('assets/logo.jpg');
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/logo.jpg');
    await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    return file;
  }*/

  Future<void> _createPDF(
      _length,
      _itemNameList,
      _itemPriceList,
      _itemQuantityList,
      _totalVat,
      _discount,
      _totalAmount,
      _customerName,
      _customerPhone,
      _remarks) async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final _rName = extractedUserData['restaurant_name'];

    //Create a PDF document.
    PdfDocument document = PdfDocument();

    //Create a border
    PdfBorders border = PdfBorders(
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
      font: PdfStandardFont(PdfFontFamily.courier, 17),
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
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    );

    final PdfPage page = document.pages.add();

    //Draw text in the header.
    page.graphics.drawString(
        '$_rName', PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: const Rect.fromLTWH(0, 3, 0, 0));
    page.graphics.drawString('Customer Name: $_customerName',
        PdfStandardFont(PdfFontFamily.helvetica, 13),
        bounds: const Rect.fromLTWH(0, 27, 200, 20));
    page.graphics.drawString('Customer Phone: $_customerPhone',
        PdfStandardFont(PdfFontFamily.helvetica, 13),
        bounds: const Rect.fromLTWH(0, 47, 200, 20));
    page.graphics.drawString(
        'Remarks: $_remarks', PdfStandardFont(PdfFontFamily.helvetica, 13),
        bounds: const Rect.fromLTWH(0, 67, 0, 0));

    /*  //Read image data.
    File file1 = _getImageLogoFile() as File;
    final Uint8List imageData = file1.readAsBytesSync();
//Load the image using PdfBitmap.
    final PdfBitmap image = PdfBitmap(imageData);
//Draw the image to the PDF page.
    page.graphics.drawImage(image, const Rect.fromLTWH(180, 27, 50, 50));*/

    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 5);
    //grid.headers.add(1);

    PdfGridRow header = grid.headers.add(1)[0];
    header.cells[0].value = 'No';
    header.cells[1].value = 'Item Name';
    header.cells[2].value = 'Quantity';
    header.cells[3].value = 'Price';
    header.cells[4].value = 'Total';

    //Apply the grid style
    grid.rows.applyStyle(gridStyle);

    PdfGridRow row;

    for (int i = 0; i <= _length + 2; i++) {
      row = grid.rows.add();
      if (i < _length) {
        row.cells[0].value = '${i + 1}';
        row.cells[1].value = '${_itemNameList[i]}';
        row.cells[2].value = '${_itemQuantityList[i]}';
        row.cells[3].value = '${_itemPriceList[i]}';
        row.cells[4].value = '${_itemQuantityList[i] * _itemPriceList[i]}';
      } else if (i == _length) {
        row.cells[0].value = '+Vat(15%)';
        row.cells[1].value = '';
        row.cells[2].value = '';
        row.cells[3].value = '';
        row.cells[4].value = '$_totalVat';
      } else if (i == _length + 1) {
        row.cells[0].value = '-Discount';
        row.cells[1].value = '';
        row.cells[2].value = '';
        row.cells[3].value = '';
        row.cells[4].value = '$_discount';
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

    grid.draw(page: page, bounds: const Rect.fromLTWH(0, 87, 0, 0));

    /**
     *
     * header date time starts
     *
     * **/

    /*
    page.graphics.drawString(
        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: Rect.fromLTWH(0, 0, 500, 40));*/

    /**
     *
     * header date time ends
     *
     * **/

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
