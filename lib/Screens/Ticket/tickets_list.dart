import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoukharid/Classes/Cards/ticket_list_card.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Screens/Ticket/chat_screen.dart';
import 'package:masoukharid/Screens/Ticket/support_ticket.dart';
import 'package:masoukharid/Services/storage_class.dart';
import 'package:shamsi_date/shamsi_date.dart';

class TicketsList extends StatefulWidget {
  const TicketsList({Key? key}) : super(key: key);
  static const String id = "TicketsListScreen";

  @override
  State<TicketsList> createState() => _TicketsListState();
}

class _TicketsListState extends State<TicketsList> {
  final storage = const FlutterSecureStorage();
  List ticketsList = [];
  List closedTicketsList = [];
  late Jalali j;

  String createdAtTimeFormatter(Jalali j) {
    final f = j.formatter;

    return '${f.wN} ${f.d} ${f.mN} ${f.yy} | ${j.hour}:${j.minute}';
  }

  String toStringFormatter(Jalali j) {
    return '${j.hour}:${j.minute}';
  }

  Future getTicketsList() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
          Uri.parse("https://testapi.carbon-family.com/api/market/tickets"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var items = jsonDecode(data)["tickets"];
        setState(() {
          for (var i = 0; i < items.length; i++) {
            if (items[i]["status"] == true) {
              ticketsList.add(items[i]);
            } else if (items[i]["status"] == false) {
              closedTicketsList.add(items[i]);
            }
            ;
          }
        });
        print(response.statusCode);
        print(response.body);
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getTicketsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'تیکت ها',
            style: TextStyle(
              fontFamily: 'IranYekan',
              color: kOrangeColor,
              fontSize: 18,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black,
          ),
          bottom: const TabBar(
            labelPadding: EdgeInsets.all(4),
            indicatorColor: Colors.black,
            indicatorWeight: 1,
            tabs: [
              Text(
                'گفت و گو های فعال',
                style: TextStyle(
                  fontFamily: "Dana",
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              Text(
                'گفت و گو های بسته شده',
                style: TextStyle(
                  fontFamily: "Dana",
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: ListView.builder(
                  itemCount: ticketsList.length,
                  itemBuilder: (context, int index) {
                    var dateAndTime =
                        DateTime.parse(ticketsList[index]["createdAt"]!)
                            .toLocal();
                    Gregorian g = Gregorian.fromDateTime(dateAndTime);
                    j = Jalali.fromGregorian(g);
                    return TicketListCard(
                      name: ticketsList[index]["lastAnsweredBy"],
                      createdAt: createdAtTimeFormatter(j),
                      time: toStringFormatter(j),
                      onTap: () {
                        Storage.ticketId = ticketsList[index]["_id"];
                        Navigator.pushNamed(context, TicketChatScreen.id);
                      },
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: ListView.builder(
                  itemCount: closedTicketsList.length,
                  itemBuilder: (context, int index) {
                    var dateAndTime =
                        DateTime.parse(closedTicketsList[index]["createdAt"]!)
                            .toLocal();
                    Gregorian g = Gregorian.fromDateTime(dateAndTime);
                    j = Jalali.fromGregorian(g);
                    return TicketListCard(
                      name: closedTicketsList[index]["lastAnsweredBy"],
                      createdAt: createdAtTimeFormatter(j),
                      time: toStringFormatter(j),
                      onTap: () {},
                    );
                  }),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, SupportTicketScreen.id);
          },
          backgroundColor: kOrangeColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
