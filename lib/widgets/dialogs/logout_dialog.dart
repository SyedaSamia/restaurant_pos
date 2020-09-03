import 'package:flutter/material.dart';
import 'package:point_of_sale6/providers/auth.dart';
import 'package:point_of_sale6/utils/size_config.dart';
import 'package:provider/provider.dart';

void showLogoutDialog(context) {
  SizeConfig().init(context);
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
          // backgroundColor: Colors.transparent,
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Are You Sure?",
            style: TextStyle(
              fontFamily: 'Source Sans Pro',
              fontSize: SizeConfig.safeBlockHorizontal * 5.5,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
            //   height: SizeConfig.blockSizeHorizontal * 30,
            // width: SizeConfig.blockSizeVertical * 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "You want to logout",
                  //  maxLines: 1,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Source Sans Pro',
                    color: Color(0xFF606060),
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeHorizontal * 3,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: new Text("Cancel",
                            style: TextStyle(
                              fontFamily: 'Source Sans Pro',
                              color: Theme.of(context).primaryColor,
                              fontSize: SizeConfig.safeBlockHorizontal * 6,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: new Text("Yes",
                            style: TextStyle(
                              fontFamily: 'Source Sans Pro',
                              color: Theme.of(context).primaryColor,
                              fontSize: SizeConfig.safeBlockHorizontal * 6,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed('/');
                          Provider.of<Auth>(context, listen: false).logout();
                        },
                      ),
                    ])
              ],
            ),
          )));
}
