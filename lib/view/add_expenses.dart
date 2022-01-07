import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:moneyflow/controller/datepicker_controller.dart';
import 'package:moneyflow/utils/services/db_helper.dart';
import 'package:flutter/services.dart';

class AddExpensesPage extends StatelessWidget {
  const AddExpensesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatePickerController _datePicker = Get.put(DatePickerController());

    double? amount;

    String note = "";
    String _selectedCategory = "Food";
    var _category = ['Food', 'Netflix', 'Shopping'];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Add Expenses'),
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: EdgeInsets.all(25),
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[800]),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.dollarSign,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                    ],
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    onChanged: (val) {
                      amount = double.parse(val);
                    },
                    decoration: InputDecoration(
                        label: Text('Amount'),
                        labelStyle: TextStyle(color: Colors.white60),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[800]),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.list,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white)),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: Colors.grey[850],
                        items: _category.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              '$value',
                              style: TextStyle(color: Colors.white60),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          _selectedCategory = val!;
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.black,
                            suffixIconColor: Colors.white,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none)),
                        value: _selectedCategory,
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[800]),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.solidStickyNote,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    onChanged: (val) {
                      note = val;
                    },
                    decoration: InputDecoration(
                        label: Text(
                          'Note',
                          style: TextStyle(color: Colors.white60),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[800]),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.calendarAlt,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey[800]!),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ))),
                          onPressed: () {
                            _datePicker.selectDate(context);
                          },
                          child: Obx(() => _datePicker.dateChanged.value == true
                              ? Text(
                                  '${_datePicker.selectedDate.day} - ${_datePicker.months[_datePicker.selectedDate.month - 1]} - ${_datePicker.selectedDate.year}')
                              : Text(
                                  '${_datePicker.selectedDate.day} - ${_datePicker.months[_datePicker.selectedDate.month - 1]} - ${_datePicker.selectedDate.year}'))),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.only(top: 20, left: 35, right: 35),
                height: 60,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey[800]!),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ))),
                    onPressed: () async {
                      if (amount != null) {
                        DbHelper dbHelper = DbHelper();
                        await dbHelper.addData(
                            amount!,
                            _datePicker.selectedDate,
                            'expenses',
                            _selectedCategory,
                            note);

                        Get.back();
                      } else {
                        print('Not all value provided');
                      }
                    },
                    child: Text('Add')))
          ],
        ),
      ),
    );
  }
}
