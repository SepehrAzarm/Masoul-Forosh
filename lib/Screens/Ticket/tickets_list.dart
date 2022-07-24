import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Classes/Cards/ticket_list_card.dart';
import 'package:masoul_kharid/Classes/Dialogs/error_dialog.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Screens/Ticket/chat_screen.dart';
import 'package:masoul_kharid/Screens/Ticket/support_ticket.dart';
import 'package:masoul_kharid/Screens/login_page.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';
import 'package:masoul_kharid/Services/storage_class.dart';
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

  int page = 1;
  int logPage = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;
  late ScrollController _closedController;

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
          Uri.parse("https://api.carbon-family.com/api/market/tickets"),
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
          }
        });
        print(response.statusCode);
        print(response.body);
      } else {
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 401) {
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPage.id,
            (Route<dynamic> route) => false,
          );
        }
        if (response.statusCode == 403) {
          showDialog(
              context: context,
              builder: (context) {
                return ErrorDialog(
                  errorText: 'شما دسترسی به این بخش را ندارید',
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      ProfileScreen.id,
                      (Route<dynamic> route) => false,
                    );
                  },
                );
              });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future laodMoreTickets() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    if (_hasNextPage == true &&
            _isFirstLoadRunning == false &&
            _isLoadMoreRunning == false &&
            _controller.position.extentAfter < 100 ||
        _closedController.position.extentAfter < 100) {
      page += 1;
      print(page);
      setState(() {
        _isLoadMoreRunning = true;
      });
      try {
        final response = await http.get(
          Uri.parse(
              "https://api.carbon-family.com/api/market/tickets?page=$page"),
          headers: headers,
        );
        final List fetchedOpenTickets = [];
        final List fetchedClosedTickets = [];
        if (response.statusCode == 200) {
          var data = response.body;
          var items = jsonDecode(data)["tickets"];
          for (var i = 0; i < items.length; i++) {
            if (items[i]["status"] == true) {
              fetchedOpenTickets.add(items[i]);
            } else if (items[i]["status"] == false) {
              fetchedClosedTickets.add(items[i]);
            }
          }
          print(response.statusCode);
          print(response.body);
        }
        if (fetchedOpenTickets.isNotEmpty) {
          setState(() {
            ticketsList.addAll(fetchedOpenTickets);
            closedTicketsList.addAll(fetchedClosedTickets);
            _isLoadMoreRunning = false;
          });
        } else {
          setState(() {
            _hasNextPage = false;
            _isLoadMoreRunning = false;
          });
        }
      } catch (err) {
        print(err);
      }
    }
  }

  @override
  void initState() {
    _controller = ScrollController()..addListener(laodMoreTickets);
    _closedController = ScrollController()..addListener(laodMoreTickets);
    getTicketsList();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(laodMoreTickets);
    _closedController.removeListener(laodMoreTickets);
    super.dispose();
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
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, ProfileScreen.id);
            },
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
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        controller: _controller,
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
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: kOrangeColor,
                        ),
                      ),
                    ),
                  if (_hasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 40),
                      child: const Center(
                        child: Text(
                          'پایان لیست',
                          style: TextStyle(
                            fontFamily: "Dana",
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        controller: _closedController,
                        itemCount: closedTicketsList.length,
                        itemBuilder: (context, int index) {
                          var dateAndTime = DateTime.parse(
                                  closedTicketsList[index]["createdAt"]!)
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
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: kOrangeColor,
                        ),
                      ),
                    ),
                  if (_hasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 40),
                      child: const Center(
                        child: Text(
                          'پایان لیست',
                          style: TextStyle(
                            fontFamily: "Dana",
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
