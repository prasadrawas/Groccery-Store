import 'package:flutter/material.dart';
import 'package:food/screens/homepage.dart';
import 'package:food/screens/loading.dart';
import 'package:food/screens/place_order.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetLocationStatus extends StatefulWidget {
  Object nav;

  GetLocationStatus({Key key, @required this.nav}) : super(key: key);

  @override
  _GetLocationStatusState createState() => _GetLocationStatusState();
}

class _GetLocationStatusState extends State<GetLocationStatus> {
  Position position;
  bool isLoading = true;
  var address;
  bool isChanged = false;
  var addr;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String city = '', area = '', pincode = '', addressLine = '';

  getLocation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("area") != null) {
      city = pref.get('city');
      area = pref.get('area');
      pincode = pref.get('pincode');
      addressLine = pref.get('addressline');
      print(pref.getString('addressline'));
      if (mounted)
        setState(() {
          isLoading = false;
        });
    } else {
      try {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        Coordinates coordinates =
            new Coordinates(position.latitude, position.longitude);
        address =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);

        if (mounted)
          setState(() {
            isLoading = false;
          });
        city = address.first.locality;
        area = address.first.thoroughfare;
        pincode = address.first.postalCode;
        addressLine = address.first.addressLine;
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  getNewLocation() async {
    final query = area + ", " + city;
    addr = await Geocoder.local.findAddressesFromQuery(query);
    addressLine = addr.first.addressLine;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('addressline', addressLine);
    pref.setDouble("lat", addr.first.coordinates.latitude);
    pref.setDouble("lng", addr.first.coordinates.longitude);
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Location',
                style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 2),
              ),
              backgroundColor: Color(0xFF202A36),
            ),
            key: _scaffoldkey,
            backgroundColor: Color(0xFF202A36),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Location Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 48,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          initialValue: city,
                          keyboardType: TextInputType.text,
                          onChanged: (s) {
                            city = s;
                            isChanged = true;
                          },
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontFamily: 'OpenSans',
                                color: Colors.black54),
                            hintText: 'Enter your City',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 48,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                            initialValue: area,
                            onChanged: (s) {
                              area = s;
                              isChanged = true;
                            },
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                              fontSize: 17,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'OpenSans',
                                  color: Colors.black54),
                              hintText: 'Enter your Area',
                              border: InputBorder.none,
                            )),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 48,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                            initialValue: pincode,
                            onChanged: (s) {
                              pincode = s;
                              isChanged = true;
                            },
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                              fontSize: 17,
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'OpenSans',
                                  color: Colors.black54),
                              hintText: 'Enter your Pincode',
                              border: InputBorder.none,
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Ink(
                        height: 40,
                        width: MediaQuery.of(context).size.width - 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(
                            0xFFF85547,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            saveAddress();
                          },
                          child: Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  _showSnackbar(BuildContext context, String error) {
    FocusScope.of(context).unfocus();
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text(error),
    ));
  }

  saveAddress() async {
    if (city != null &&
        area != null &&
        pincode != null &&
        city.length >= 4 &&
        area.length >= 4 &&
        pincode.length >= 4) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("city", city);
        pref.setString("area", area);
        pref.setString("pincode", pincode);
        pref.setString('addressline', addressLine);
        if (isChanged) {
          await getNewLocation();
        } else {
          pref.setDouble("lat", position.latitude);
          pref.setDouble("lng", position.longitude);
        }

        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => widget.nav));
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        _showSnackbar(context, 'Please enter valid address !');
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      _showSnackbar(context, 'Please enter valid address !');
    }
  }
}
