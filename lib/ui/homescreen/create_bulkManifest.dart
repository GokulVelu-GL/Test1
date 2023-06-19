import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/emanifest_model.dart';
import 'package:rooster/model/manifest_bulkModel.dart';
import 'package:rooster/ui/drodowns/airline_code.dart';
import 'package:rooster/ui/drodowns/airport_code.dart';

class CreateManifestBulk extends StatefulWidget {
  bool isBulk;
  CreateManifestBulk({Key key, this.isBulk}) : super(key: key);

  @override
  State<CreateManifestBulk> createState() => _CreateManifestBulkState();
}

class _CreateManifestBulkState extends State<CreateManifestBulk> {
  final List<ExpenseList> expenseList = [];
  final _formKey = GlobalKey<FormState>();
  String segement = "176";
  String name = '';

  String airline;
  String masterAWB;
  String origin;
  String destination;
  String pieces;
  String totalpieces;

  String weight;
  String totalweight;
  String weightUnit = 'K';
  String mash;
  String mash1;
  String dg;
  String mc;
  String nature_of_goods;
  String volume;
  String uldtype;
  String uldno;
  String uldCode;

  String volumeUnit = "MC";
  String Nature_Of_Goods;
  String Customs_Exam_Indicator;
  String Customs_Exam_OrderNo;
  String Customs_Exam_DateTime;
  String Scan_Type;
  String Internal_Remarks;
  String manifestRemarks;
  String officeUseRemarks;
  bool _customTileExpanded = false;
  bool _expendRemarks = false;
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController originController = TextEditingController();
  final TextEditingController masterController = TextEditingController();
  final TextEditingController airlineController = TextEditingController();

  @override
  void initState() {
    print("object");
    uldList();
    setState(() {
      mash = "master";
      mash1 = "None";
      _customTileExpanded = true;
      _expendRemarks = true;
    });
    super.initState();
  }

  Widget uldList() {
    return AlertDialog(
      title: Center(child: const Text('Select ULD')),
      content:
          //userid.isNotEmpty
          Container(
        height: 200,
        width: 300,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AKE11111SQ',
                        style: TextStyle(color: Colors.orangeAccent),
                      ),
                      Text(
                        'AKE15021SQ',
                        style: TextStyle(color: Colors.orangeAccent),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manifest ULD',
                          // '${ipaddr[index]}',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                        Text(
                          'Manifest ULD',
                          // '${ipaddr[index]}',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        Center(
          child:  TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CreateManifestBulk(
                        isBulk: false,
                      )));
            },
            //textColor: Theme.of(context).primaryColor,
            child: const Text('Create New'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ManifestModel>(builder: (context, model, child) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            title: Text(
              "Manage AWB in Flight Manifest",
            ),
          ),
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!widget.isBulk)
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "ULD Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor),
                        ),
                      ),
                    if (!widget.isBulk)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                inputFormatters: [AllCapitalCase()],
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    border: OutlineInputBorder(
                                        gapPadding: 2.0,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    labelText: "Type",
                                    labelStyle: TextStyle(
                                        color: Theme.of(context).accentColor)
                                    //'Pieces',
                                    ),
                                validator: (value) {
                                  if (value.isEmpty || value == null) {
                                    return "Please Enter the type";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    uldtype = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                inputFormatters: [AllCapitalCase()],
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    border: OutlineInputBorder(
                                        gapPadding: 2.0,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    labelText: "Number",
                                    labelStyle: TextStyle(
                                        color: Theme.of(context).accentColor)
                                    //'Pieces',
                                    ),
                                validator: (value) {
                                  if (value.isEmpty || value == null) {
                                    return "Please Enter the number";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    uldno = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                inputFormatters: [AllCapitalCase()],
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    border: OutlineInputBorder(
                                        gapPadding: 2.0,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    labelText: "OwnerCode",
                                    labelStyle: TextStyle(
                                        color: Theme.of(context).accentColor)
                                    //'Pieces',
                                    ),
                                validator: (value) {
                                  if (value.isEmpty || value == null) {
                                    return "Please Enter the code";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    uldCode = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "AWB Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: airlineTF(),
                            flex: 3,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: masterAWBTF(),
                            flex: 7,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: originTF(),
                            flex: 4,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: destinationTF(),
                            flex: 4,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: piecesTF(),
                            flex: 4,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TotalPieces(),
                            flex: 4,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: weightTF(),
                            flex: 4,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TotalWeight(),
                            flex: 4,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: weightUnitTF(),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SpecialHandling(),
                            flex: 4,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: SpecialHandling(),
                            flex: 4,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: SpecialHandling(),
                            flex: 4,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          border:
                              Border.all(color: Theme.of(context).accentColor)),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(
                                "Master",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                              leading: Radio(
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) =>
                                          Theme.of(context).accentColor),
                                  value: "master",
                                  groupValue: mash,
                                  onChanged: (value) {
                                    setState(() {
                                      mash = value.toString();
                                    });
                                  }),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                "House",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                              leading: Radio(
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) =>
                                          Theme.of(context).accentColor),
                                  value: "House",
                                  groupValue: mash,
                                  onChanged: (value) {
                                    setState(() {
                                      mash = value.toString();
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border:
                            Border.all(color: Theme.of(context).accentColor),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    "None",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                  leading: Radio(
                                      fillColor: MaterialStateColor.resolveWith(
                                          (states) =>
                                              Theme.of(context).accentColor),
                                      value: "None",
                                      groupValue: mash1,
                                      onChanged: (value) {
                                        setState(() {
                                          mash1 = value.toString();
                                        });
                                      }),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    "Part",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                  leading: Radio(
                                      fillColor: MaterialStateColor.resolveWith(
                                          (states) =>
                                              Theme.of(context).accentColor),
                                      value: "Part",
                                      groupValue: mash1,
                                      onChanged: (value) {
                                        setState(() {
                                          mash1 = value.toString();
                                        });
                                      }),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    "Split",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                  leading: Radio(
                                      fillColor: MaterialStateColor.resolveWith(
                                          (states) =>
                                              Theme.of(context).accentColor),
                                      value: "Split",
                                      groupValue: mash1,
                                      onChanged: (value) {
                                        setState(() {
                                          mash1 = value.toString();
                                        });
                                      }),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    "Divide",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                  leading: Radio(
                                      fillColor: MaterialStateColor.resolveWith(
                                          (states) =>
                                              Theme.of(context).accentColor),
                                      value: "Divide",
                                      groupValue: mash1,
                                      onChanged: (value) {
                                        setState(() {
                                          mash1 = value.toString();
                                        });
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //dg
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              inputFormatters: [AllCapitalCase()],
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  border: OutlineInputBorder(
                                      gapPadding: 2.0,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  labelText: "DG",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor)
                                  //'Pieces',
                                  ),
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return "Please Enter the pieces";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  dg = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              inputFormatters: [AllCapitalCase()],
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  border: OutlineInputBorder(
                                      gapPadding: 2.0,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  labelText: "Volume",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor)
                                  //'Pieces',
                                  ),
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return "Please Enter the pieces";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  volume = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(flex: 2, child: VolumeUnit()),
                        ],
                      ),
                    ),
                    //MC/CF AND nature of goods
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              inputFormatters: [AllCapitalCase()],
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  border: OutlineInputBorder(
                                      gapPadding: 2.0,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  labelText: "Nature Of Goods",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor)
                                  //'Pieces',
                                  ),
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return "Please Enter the pieces";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  Nature_Of_Goods = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    ExpansionTile(
                      title: Text(
                        "Customs_Exam",
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                      trailing: Icon(
                        _customTileExpanded
                            ? Icons.arrow_drop_down
                            : Icons.info,
                        color: Theme.of(context).accentColor,
                      ),
                      children: [
                        //custom Exam indicator and custom remark
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [AllCapitalCase()],
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      border: OutlineInputBorder(
                                          gapPadding: 2.0,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      labelText: "Indicator",
                                      labelStyle: TextStyle(
                                          color: Theme.of(context).accentColor)
                                      //'Pieces',
                                      ),
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Please Enter the Customs Remarks";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      Customs_Exam_Indicator = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [AllCapitalCase()],
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      border: OutlineInputBorder(
                                          gapPadding: 2.0,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      labelText: "Customs Remarks",
                                      labelStyle: TextStyle(
                                          color: Theme.of(context).accentColor)
                                      //'Pieces',
                                      ),
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Please Enter the Customs Remarks";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      volume = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Custom Exam Order number and Exam officer Name
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [AllCapitalCase()],
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      border: OutlineInputBorder(
                                          gapPadding: 2.0,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      labelText: "OrderNo",
                                      labelStyle: TextStyle(
                                          color: Theme.of(context).accentColor)
                                      //'Pieces',
                                      ),
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Please Enter the Customs_Exam_OrderNo";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      Customs_Exam_OrderNo = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [AllCapitalCase()],
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      border: OutlineInputBorder(
                                          gapPadding: 2.0,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      labelText: "OfficerName",
                                      labelStyle: TextStyle(
                                          color: Theme.of(context).accentColor)
                                      //'Pieces',
                                      ),
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Please Enter the Customs_Exam_OfficerName";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      volume = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Customs_Exam_Date
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [AllCapitalCase()],
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      border: OutlineInputBorder(
                                          gapPadding: 2.0,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      labelText: "DateTime",
                                      labelStyle: TextStyle(
                                          color: Theme.of(context).accentColor)
                                      //'Pieces',
                                      ),
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Please Enter the Customs_Exam_OrderNo";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      Customs_Exam_DateTime = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [AllCapitalCase()],
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      border: OutlineInputBorder(
                                          gapPadding: 2.0,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      labelText: "Scanned_Indicator",
                                      labelStyle: TextStyle(
                                          color: Theme.of(context).accentColor)
                                      //'Pieces',
                                      ),
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Please Enter the Scanned_Indicator";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      volume = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      initiallyExpanded: true,
                      onExpansionChanged: (bool expanded) {
                        setState(() => _customTileExpanded = expanded);
                      },
                    ),

                    //Scan type and Shipping Bill
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              inputFormatters: [AllCapitalCase()],
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  border: OutlineInputBorder(
                                      gapPadding: 2.0,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  labelText: "Scan Type",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor)
                                  //'Pieces',
                                  ),
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return "Please Enter the Scan Type";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  Scan_Type = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              inputFormatters: [AllCapitalCase()],
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  border: OutlineInputBorder(
                                      gapPadding: 2.0,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  labelText: "Shipping_Bill_No",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor)
                                  //'Pieces',
                                  ),
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return "Please Enter the Scanned_Indicator";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  volume = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Internal Remarks and Manifest Remarks
                    ExpansionTile(
                      title: Text(
                        "Remarks",
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                      trailing: Icon(
                        _expendRemarks ? Icons.arrow_drop_down : Icons.info,
                        color: Theme.of(context).accentColor,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [AllCapitalCase()],
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      border: OutlineInputBorder(
                                          gapPadding: 2.0,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      labelText: "Internal",
                                      labelStyle: TextStyle(
                                          color: Theme.of(context).accentColor)
                                      //'Pieces',
                                      ),
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Please Enter the Internal Remarks";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      Internal_Remarks = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [AllCapitalCase()],
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      border: OutlineInputBorder(
                                          gapPadding: 2.0,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      labelText: "Manifest",
                                      labelStyle: TextStyle(
                                          color: Theme.of(context).accentColor)
                                      //'Pieces',
                                      ),
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Please Enter the Manifest Remarks";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      manifestRemarks = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            inputFormatters: [AllCapitalCase()],
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                //border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                border: OutlineInputBorder(
                                    gapPadding: 2.0,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                labelText: "For Office Use",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor)
                                //'Pieces',
                                ),
                            validator: (value) {
                              if (value.isEmpty || value == null) {
                                return "Please Enter the For Office Use Remarks";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                officeUseRemarks = value;
                              });
                            },
                          ),
                        ),
                      ],
                      initiallyExpanded: true,
                      onExpansionChanged: (bool expanded) {
                        setState(() => _expendRemarks = expanded);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                          icon: Icon(Icons.clear,
                              color: Theme.of(context).backgroundColor),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).accentColor)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          label: Text(
                            'Close',
                            style: TextStyle(
                                color: Theme.of(context).backgroundColor),
                          ),
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.save,
                              color: Theme.of(context).backgroundColor),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).accentColor)),
                          onPressed: () async {
                            EasyLoading.show(status: 'Please wait...');
                            ManifestBulkModel items = ManifestBulkModel(
                                awbNumber: masterAWB,
                                prefix: airlineController.text,
                                origin: originController.text,
                                destination: destinationController.text,
                                pieces: pieces,
                                totalPieces: totalpieces,
                                weight: weight,
                                totalWeight: totalweight,
                                dg: dg,
                                volume: volume,
                                volumeUnit: volumeUnit,
                                natureOfGoods: nature_of_goods,
                                customsExamIndicator: Customs_Exam_Indicator,
                                customsExamDateTime: Customs_Exam_DateTime,
                                customsExamOrderNo: Customs_Exam_OrderNo,
                                scanType: Scan_Type,
                                internalRemarks: Internal_Remarks,
                                manifestRemarks: manifestRemarks,
                                officeUseRemarks: officeUseRemarks);
                            model.bulkList.add(items);

                            //model.printeManifest();
                            await Future.delayed(Duration(seconds: 1));
                            EasyLoading.dismiss();
                            // addEmail(
                            //     segement.toString(),
                            //     airlineController.text,
                            //     masterAWB.toString(),
                            //     originController.text,
                            //     destinationController.text,
                            //     pieces.toString(),
                            //     totalpieces.toString(),
                            //     weight.toString(),
                            //     totalweight.toString(),
                            //     weightUnit.toString(),
                            //     mash.toString(),
                            //     DG.toString(),
                            //     volume.toString(),
                            //     volumeUnit.toString(),
                            //     Nature_Of_Goods.toString(),
                            //     Customs_Exam_Indicator.toString(),
                            //     Customs_Exam_OrderNo.toString(),
                            //     Customs_Exam_DateTime.toString(),
                            //     Scan_Type.toString(),
                            //     Internal_Remarks.toString(),
                            //     manifestRemarks.toString(),
                            //     officeUseRemarks.toString()

                            //     //airline.toString()

                            //     // origin.toString()

                            //     );
                            Navigator.pop(context);
                          },
                          label: Text(
                            "Submit",
                            style: TextStyle(
                                color: Theme.of(context).backgroundColor),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
    });
  }

  airlineTF() {
    final focus = FocusNode();
    return TypeAheadFormField<AirlineCode>(
        suggestionsCallback: AirlineCodeApi.getAirlineCode,
        itemBuilder: (context, AirlineCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airlineCode),
            subtitle: Text(code.airlineName),
          );
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Select a Airline';
          }
          return null;
        },
        textFieldConfiguration: TextFieldConfiguration(
          maxLength: 3,
          controller: this.airlineController,
          inputFormatters: [AllCapitalCase()],
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: S.of(context).Airline,
              labelStyle: TextStyle(color: Theme.of(context).accentColor)
              //'Airline',
              ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSuggestionSelected: (AirlineCode suggestion) {
          this.airlineController.text = suggestion.airlinePrifix;
          airline = suggestion.airlinePrifix;
          print(airline);
        });
  }

  masterAWBTF() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      maxLength: 8,
      // inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: S.of(context).MasterAWB,
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
          //'Master AWB',
          ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          print("object");
          return "Please Enter the AWB No";
        } else if (value.length != 8) {
          return "AWB number must be 8 digit";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          masterAWB = value;
          //print('${masterAWB}');
        });
      },
    );
  }

  originTF() {
    return TypeAheadFormField<AirportCode>(
        suggestionsCallback: AirportApi.getAirportCode,
        itemBuilder: (context, AirportCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airportCode),
            subtitle: Text(code.airportName),
          );
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Select a Origin';
          }
          return null;
        },
        textFieldConfiguration: TextFieldConfiguration(
          inputFormatters: [AllCapitalCase()],
          controller: this.originController,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: S.of(context).Origin,
              labelStyle: TextStyle(color: Theme.of(context).accentColor)
              //'Origin',
              ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSuggestionSelected: (AirportCode suggestion) {
          if (suggestion.airportCode == null &&
              suggestion.airportName == null) {
            return 'Worong Code';
          } else {
            this.originController.text = suggestion.airportCode;
            origin = suggestion.airportCode;
            print(origin);
          }
        });
  }

  destinationTF() {
    final focus = FocusNode();
    return TypeAheadFormField<AirportCode>(
        suggestionsCallback: AirportApi.getAirportCode,
        itemBuilder: (context, AirportCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airportCode),
            subtitle: Text(code.airportName),
          );
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Select a Destination';
          }
          return null;
        },
        textFieldConfiguration: TextFieldConfiguration(
          controller: this.destinationController,
          inputFormatters: [AllCapitalCase()],
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: S.of(context).Destination,
              labelStyle: TextStyle(color: Theme.of(context).accentColor)
              //'Destination',
              ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSuggestionSelected: (AirportCode suggestion) {
          this.destinationController.text = suggestion.airportCode;
          destination = suggestion.airportCode;
          print(destination);
        });
  }

  piecesTF() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: S.of(context).Pieces,
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
          //'Pieces',
          ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return "Please Enter the pieces";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          pieces = value;
        });
      },
    );
  }

  TotalPieces() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: "Total Pieces",
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
          //'Pieces',
          ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return "Please Enter the pieces";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          totalpieces = value;
        });
      },
    );
  }

  weightTF() {
    return Container(
      width: 170,
      child: TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        inputFormatters: [AllCapitalCase()],
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).accentColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            //border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).accentColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            border: OutlineInputBorder(
                gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).Weight,
            labelStyle: TextStyle(color: Theme.of(context).accentColor)
            //'Weight',
            ),
        validator: (value) {
          if (value.isEmpty || value == null) {
            return "Please Enter the weight";
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            weight = value;
          });
        },
      ),
    );
  }

  weightUnitTF() {
    return DropdownButton<String>(
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).accentColor,
      ),
      value: weightUnit,
      items: ['K', 'L'].map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                style: TextStyle(color: Theme.of(context).accentColor)),
          );
        },
      ).toList(),
      onChanged: (String text) {
        setState(
          () {
            weightUnit = text;
          },
        );
      },
    );
  }

  VolumeUnit() {
    return DropdownButton<String>(
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).accentColor,
      ),
      value: volumeUnit,
      items: ['MC', 'CF'].map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                style: TextStyle(color: Theme.of(context).accentColor)),
          );
        },
      ).toList(),
      onChanged: (String text) {
        setState(
          () {
            volumeUnit = text;
          },
        );
      },
    );
  }

  TotalWeight() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: "Total Weight",
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
          //'Pieces',
          ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return "Please Enter the pieces";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          totalweight = value;
        });
      },
    );
  }

  SpecialHandling() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: "SPH",
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
          //'Pieces',
          ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return "Please Enter the pieces";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          pieces = value;
        });
      },
    );
  }
}

class ExpenseList {
  String title;
  String id;
  String serialNo;
  String origin;
  String destination;
  String pieces;
  String total_pieces;
  String weight;
  String total_weight;
  String weight_unit;
  String mash;
  String dg;
  String volume;
  String volumeUnit;
  String Nature_Of_Goods;
  String Customs_Exam_Indicator;
  String Customs_Exam_OrderNo;
  String Customs_Exam_DateTime;
  String Scan_Type;
  String Internal_Remarks;
  String manifestRemarks;
  String officeUseRemarks;

  ExpenseList({
    @required this.title,
    @required this.id,
    @required this.serialNo,
    @required this.origin,
    @required this.destination,
    @required this.pieces,
    @required this.total_pieces,
    @required this.weight,
    @required this.total_weight,
    @required this.weight_unit,
    @required this.mash,
    @required this.dg,
    @required this.volume,
    @required this.volumeUnit,
    @required this.Nature_Of_Goods,
    @required this.Customs_Exam_Indicator,
    @required this.Customs_Exam_OrderNo,
    @required this.Customs_Exam_DateTime,
    @required this.Scan_Type,
    @required this.Internal_Remarks,
    @required this.manifestRemarks,
    @required this.officeUseRemarks,
  });
}
