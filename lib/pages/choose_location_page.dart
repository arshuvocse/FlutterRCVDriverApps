import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../controllers/choose_location_controller.dart';

class ChooseLocationPage extends StatefulWidget {
  const ChooseLocationPage({super.key});

  @override
  State<ChooseLocationPage> createState() => _ChooseLocationPageState();
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  late final ChooseLocationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChooseLocationController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.init());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<ChooseLocationController>(
        builder: (context, controller, _) {
          final selected = controller.selectedLatLng;
          final markers = <Marker>{
            if (selected != null)
              Marker(
                markerId: const MarkerId('selected'),
                position: selected,
                infoWindow:
                    InfoWindow(title: controller.selectedAddress ?? 'Selected'),
              ),
          };
          return Scaffold(
            appBar: AppBar(
              title: const Text('Change Location'),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFEE4A7), Color(0xFFFEE4A7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.searchCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Search location',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: controller.searchPlaces,
                          onTap: () => _showSearchSheet(context, controller),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.my_location),
                        onPressed: controller.useCurrentLocation,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(25.2048, 55.2708),
                      zoom: 12,
                    ),
                    onMapCreated: controller.onMapCreated,
                    markers: markers,
                    onTap: controller.onMapTap,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                  ),
                ),
                Container(
                  color: Colors.black.withValues(alpha: 0.65),
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    controller.selectedAddress ?? 'Selected Location',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: controller.isLoading
                            ? null
                            : () async {
                                final ok = await controller.updateLocation(context);
                                if (!context.mounted) return;
                                if (ok) {
                                  Navigator.pop(context, true);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please choose your location before proceeding.'),
                                    ),
                                  );
                                }
                              },
                        child: controller.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Update',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSearchSheet(
    BuildContext context,
    ChooseLocationController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller.searchSheetCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Search location',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) async {
                        await controller.searchPlaces(v);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    if (controller.predictions.isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: controller.predictions.length,
                          itemBuilder: (context, index) {
                            final p = controller.predictions[index];
                            return ListTile(
                              title: Text(p.description),
                              onTap: () async {
                                await controller.choosePrediction(p);
                                setState(() {});
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const SizedBox(
                            width: 100,
                            child: Center(child: Text('Cancel')),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            width: 100,
                            child: Center(child: Text('Search')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
