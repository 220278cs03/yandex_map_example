import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../controller/main_controller.dart';

class MyYandexMap extends StatefulWidget {
  const MyYandexMap({Key? key}) : super(key: key);

  @override
  State<MyYandexMap> createState() => _MyYandexMapState();
}

class _MyYandexMapState extends State<MyYandexMap> {
  late YandexMapController yandexMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          YandexMap(
            mapObjects: [
              PlacemarkMapObject(
                mapId: MapObjectId("1"),
                point: Point(latitude: 41.285416, longitude: 69.284007),
                icon: PlacemarkIcon.single(PlacemarkIconStyle(image: BitmapDescriptor.fromAssetImage("assets/nt_logo.png"), scale: 0.5))
              )
            ],
            onMapCreated: (YandexMapController controller) {
              yandexMapController = controller;
              yandexMapController.moveCamera(
                CameraUpdate.newCameraPosition(
                  const CameraPosition(
                      target: Point(latitude: 41.285416, longitude: 69.204007)),
                ),
              );
            },
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(top: 16, right: 24, left: 24),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    onChanged: (s) {
                      context.read<MainController>().search(s);
                    },
                    decoration: const InputDecoration(
                      hintText: "Search",
                    ),
                  ),
                  (context.watch<MainController>().searchText?.isNotEmpty ??
                          false)
                      ? FutureBuilder(
                          future: YandexSearch.searchByText(
                                  searchText: context
                                          .watch<MainController>()
                                          .searchText ??
                                      "",
                                  geometry: Geometry.fromBoundingBox(
                                      const BoundingBox(
                                          northEast: Point(
                                              longitude: 55.9289172707,
                                              latitude: 37.1449940049),
                                          southWest: Point(
                                              longitude: 73.055417108,
                                              latitude: 45.5868043076))),
                                  searchOptions: const SearchOptions(
                                      searchType: SearchType.none,
                                      geometry: true))
                              .result,
                          builder: (context, value) {
                            if (value.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: value.data?.items?.length ?? 0,
                                  itemBuilder: (context2, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        context
                                            .read<MainController>()
                                            .search("");
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                            "${value.data?.items?[index].name} , ${value.data?.items?[index].businessMetadata?.address.formattedAddress ?? ""}" ??
                                                ""),
                                      ),
                                    );
                                  });
                            } else if (value.hasError) {
                              return Text(value.error.toString());
                            } else {
                              return const CircularProgressIndicator();
                            }
                          })
                      : const SizedBox.shrink()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
