import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web_event/Services/EventProvider.dart';
import 'package:web_event/Services/auth_services.dart';
import 'package:web_event/constants.dart';
import 'package:web_event/models/EventModel.dart';

class MainPageContainer extends StatefulWidget {
  const MainPageContainer({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageContainerState();
}

class _MainPageContainerState extends State<MainPageContainer>
    with SingleTickerProviderStateMixin {
  EventModel? selectedEvent;

  late TabController _tabController;

  // final Function(String) onTabChanged;
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(12.971599, 77.594566);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          children: [
            Expanded(flex: 1, child: Header()),
            Expanded(
              flex: 6,
              child: Row(
                children: [
                  Expanded(flex: 2, child: SideMenuContainer()),
                  Expanded(flex: 4, child: EventDetailContainer()),
                ],
              ),
            )
          ],
        ));
  }

  Widget SideMenuContainer() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Serchfield(),
              ListViewContainer(),
              Container(
                width: 150,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: ElevatedButton(
                  onPressed: () {},
                  style: const ButtonStyle(),
                  child: const Text("VIew More"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Serchfield() {
    return Expanded(
        child: TextField(
      decoration: InputDecoration(
          hintText: "Search",
          fillColor: Colors.blue,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: InkWell(
            onTap: () {},
            child: const Icon(Icons.search),
          )),
    ));
  }

  Widget ListViewContainer() {
    return Consumer<Eventprovider>(builder: (context, eventProvider, child) {
      return Container(
          height: MediaQuery.sizeOf(context).height * 0.7,
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: eventProvider.events.length,
              itemBuilder: (context, index) {
                final event = eventProvider.events[index];
                return GestureDetector(
                  onTap: () {
                    eventProvider.selectEvent(event);
                  },
                  child: ListTailContainer(event),
                );
              }));
    });
  }

  Widget ListTailContainer(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: MediaQuery.sizeOf(context).height * 0.1,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  const Icon(Icons.date_range),
                  Expanded(
                      child: Text(
                    event.startDateTime,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  )),
                ],
              )),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  event.address,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  event.eventName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget EventDetailContainer() {
    return Consumer<Eventprovider>(builder: (context, eventProvider, child) {
      final selectedEvent = eventProvider.selectedEvent ??
          (eventProvider.events.isNotEmpty ? eventProvider.events.first : null);
      if (selectedEvent == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Column(
                  children: [
                    TopBarContainer(selectedEvent),
                    Row(
                      children: [
                        Expanded(flex: 2, child: LeftContainer(selectedEvent)),
                        Expanded(flex: 2, child: RightContainer(selectedEvent)),
                      ],
                    ),
                    BottomContainer(selectedEvent),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget TopBarContainer(EventModel selectedEvent) {
    return Container(
      color: Colors.transparent,
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            selectedEvent.id,
            overflow: TextOverflow.clip,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                selectedEvent.startDateTime,
                overflow: TextOverflow.clip,
              ),
              Text(selectedEvent.endDateTiem, overflow: TextOverflow.clip),
            ],
          ),
          Text(selectedEvent.status, overflow: TextOverflow.clip)
        ],
      ),
    );
  }

  Widget LeftContainer(EventModel selectedEvent) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.52,
      width: MediaQuery.sizeOf(context).width * 0.3,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.25,
            width: MediaQuery.sizeOf(context).width * 0.3,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(selectedEvent.image.isNotEmpty
                    ? selectedEvent.image
                    : 'https://via.placeholder.com/150'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.25,
            width: MediaQuery.sizeOf(context).width * 0.3,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: _center, zoom: 11.0)),
          )
        ],
      ),
    );
  }

  Widget RightContainer(EventModel selectedEvent) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.52,
      width: MediaQuery.sizeOf(context).width * 0.3,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.07,
            width: MediaQuery.sizeOf(context).width * 0.3,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.date_range_rounded),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Starting Time"),
                            Expanded(
                                child: Text(
                              selectedEvent.startDateTime,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ))
                          ],
                        ))),
              ],
            ),
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.07,
            width: MediaQuery.sizeOf(context).width * 0.3,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.date_range_rounded),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Ending Time"),
                            Expanded(
                                child: Text(
                              selectedEvent.endDateTiem,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ))
                          ],
                        ))),
              ],
            ),
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.07,
            width: MediaQuery.sizeOf(context).width * 0.3,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.date_range_rounded),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Category"),
                            Expanded(
                                child: Text(
                              selectedEvent.eventCategory,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ))
                          ],
                        ))),
              ],
            ),
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.07,
            width: MediaQuery.sizeOf(context).width * 0.3,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.date_range_rounded),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Price"),
                            Expanded(
                                child: Text(
                              selectedEvent.price,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ))
                          ],
                        ))),
              ],
            ),
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.0705,
            width: MediaQuery.sizeOf(context).width * 0.3,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.date_range_rounded),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Address"),
                            Expanded(
                              child: Text(
                                selectedEvent.address,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            )
                          ],
                        ))),
              ],
            ),
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.14,
            width: MediaQuery.sizeOf(context).width * 0.3,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.date_range_rounded),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Description"),
                            Expanded(
                                child: Text(
                              selectedEvent.description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 6,
                            ))
                          ],
                        ))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget BottomContainer(EventModel selectedEvent) {
    final firestoreProvider = Provider.of<Eventprovider>(context);

    return Container(
      height: 100,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 125,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: ElevatedButton(
              onPressed: () {
                firestoreProvider.updateField(
                    collectionPath: "events",
                    docId: selectedEvent.id,
                    field: "status",
                    newValue: "Approved");
                showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                          title: Icon(Icons.scuba_diving),
                          content: Text("Success"),
                        ));
              },
              style: const ButtonStyle(),
              child: const Text("Approve"),
            ),
          ),
          Container(
            width: 125,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: ElevatedButton(
              onPressed: () {
                firestoreProvider.updateField(
                    collectionPath: "events",
                    docId: selectedEvent.id,
                    field: "status",
                    newValue: "Rejected");
              },
              style: const ButtonStyle(),
              child: const Text("Reject"),
            ),
          ),
        ],
      ),
    );
  }

  Widget Header() {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.10,
        width: MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.all(defaultPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 247, 247, 247),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.white)),
        child: Row(
          children: [
            const Icon(Icons.person),
            Expanded(flex: 4, child: Labels()),
            ProfileCard()
          ],
        ));
  }

  Widget ProfileCard() {
    AuthService authService = AuthService();
    return Container(
        margin: const EdgeInsets.only(left: defaultPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        child: IconButton(onPressed: ()async {
          await authService.signout(context: context);
          

        }, icon: Icon(Icons.logout_rounded)));
  }

  Widget Labels() {
    const List<String> tabValues = ["Pending", "Approved", "Rejected"];
    return DefaultTabController(
        length: tabValues.length,
        child: Column(
          children: [
            TabBar(
                onTap: (index) {
                  String tabvalue = tabValues[index];
                  Provider.of<Eventprovider>(context, listen: false)
                      .fetchLable(tabvalue);
                },
                tabs: tabValues
                    .map((value) => Tab(
                          text: value,
                        ))
                    .toList())
          ],
        ));
  }
}
