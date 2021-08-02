import 'package:adress_book/service/addressClass.dart';
import 'package:adress_book/service/databaseClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adress_book/service/global.dart' as global;
class AddressListPage extends StatefulWidget {
  const AddressListPage({Key? key}) : super(key: key);

  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {

  List<Widget> addressInfoList = [];

  Widget list = Container();

  void getAddressList() async{
    addressInfoList.clear();

    DatabaseClass databaseClass = DatabaseClass();

    List<AddressClass> addressList = await databaseClass.getAddressList();

    if(addressList.isEmpty){
      setState(() {
        list = Center(
            child: Text(
                'No data found',
              style: TextStyle(
                color: Colors.grey[500]
              ),
            )
        );
      });
      return;
    }

    for(int index = 0; index < addressList.length; index++){
      Map addressData = addressList.elementAt(index).toMap();
      String name = addressData['name'];
      String city = addressData['city'];
      String country = addressData['country'];
      String address = addressData['address'];
      String id = addressData['id'];
      String phone = addressData['phone'];
      addressInfoList.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
          child: SizedBox(
            height: 120,
            child: Container(
              child: InkWell(
                onTap: (){

                },
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color: (Colors.grey[400])!
                                  )
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Address: $address, $city, $country',
                                      style: TextStyle(
                                        color: Colors.grey[600]
                                      ),
                                    )
                                ),
                                Expanded(
                                  child: Text(
                                    phone,
                                    style: TextStyle(
                                        color: Colors.grey[600]
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: (){
                                      databaseClass.deleteAddress(id);
                                      getAddressList();
                                    },
                                    icon: Icon(Icons.delete)
                                )
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      );
    }

    setState(() {

      addressInfoList = addressInfoList;

      list = ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: addressInfoList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              child: addressInfoList[index],
            );
          }
      );
    });

  }

  @override
  void initState() {
    super.initState();
    
    setState(() {
      list = Center(
        child: SpinKitCircle(
          color: Colors.grey[500],
          size: 50.0,
          duration: const Duration(milliseconds: 1200),
        ),
      );
    });
    
    getAddressList();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: Scaffold(
          appBar: global.defaultAppBar,
          body: Stack(
            children: [
              ListView(
                shrinkWrap: false,
                children: [
                  SizedBox(height: 10,),
                  Center(
                    child: Text(
                      'Address List',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  list,

                ],
              ),
              Positioned(
                right: 30,
                bottom: 30,
                child: FloatingActionButton(
                  onPressed: (){
                    Future.delayed(Duration.zero, ()
                    {
                      Navigator.pushNamed(context, '/map');
                    });
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.blueAccent,
                ),
              )
            ],
          ),
        )
    );
  }
}
