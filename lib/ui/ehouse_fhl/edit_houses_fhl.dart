import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/fhl_model.dart';

import 'static/add_fhl_house.dart';

class EditHousesFHL extends StatefulWidget {
  final String masterAWB;

  EditHousesFHL(this.masterAWB);

  @override
  _EditHousesFHLState createState() => new _EditHousesFHLState();
}

class _EditHousesFHLState extends State<EditHousesFHL> {
  List<FHLModel> _listFHLModel = List<FHLModel>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).HouseListfor+
            //'House List for'
            '${widget.masterAWB}'),
      ),
      floatingActionButton: buildAddButton(),
      body: new ListView.builder(
        itemCount: _listFHLModel.length,
        itemBuilder: (context, i) {
          return Dismissible(
            key: ValueKey(_listFHLModel[i]),
            onDismissed: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                setState(() {
                  _listFHLModel.removeAt(i);
                });
              }
            },
            confirmDismiss: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:  Text(
                          S.of(context).DeleteConfirmation,
                         // "Delete Confirmation"
                      ),
                      content:  Text(
                        S.of(context).Areyousureyouwanttodeletethisitem,

                        //  "Are you sure you want to delete this item?"

                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child:  Text(
                               S.of(context).Delete,
                              // "Delete"
                            )),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child:  Text(
                           S.of(context).Cancel,
                            //  "Cancel"
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                FHLModel _editedFHLModel = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFHLHouse(
                        fhlModel: _listFHLModel[i],
                        isView: false,
                      ),
                      fullscreenDialog: true,
                    ));

                if (_editedFHLModel != null) {
                  setState(() {
                    _listFHLModel.removeAt(i);
                    _listFHLModel.insert(i, _editedFHLModel);
                  });
                }
                return false;
              }
            },
            child: buildListItemOfHouses(i),
            background: Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        S.of(context).Delete,
                        //'Delete'
                         style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(Icons.edit, color: Colors.white),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                     S.of(context).EditHouse,
                     // 'Edit House',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildListItemOfHouses(int i) {
    return ListTile(
      title: Text(
        _listFHLModel[i].houseDetailsNumber,
        style: TextStyle(fontSize: 20),
      ),
      subtitle: Text(
        '${_listFHLModel[i].quantityDetailsPieces} pieces with ${_listFHLModel[i].quantityDetailsWeight} ${_listFHLModel[i].quantityDetailsWeightUnit}',
        style: TextStyle(fontSize: 15),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddFHLHouse(
              fhlModel: _listFHLModel[i],
              isView: true,
            ),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }

  Widget buildAddButton() {
    return Builder(
      builder: (context) => FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () async {
          FHLModel _newFHLModel = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddFHLHouse(
                  isView: false,
                ),
                fullscreenDialog: true,
              ));

          if (_newFHLModel != null) {
            setState(() {
              _listFHLModel.add(_newFHLModel);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
