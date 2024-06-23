import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/site_data_controller.dart';
import '../Widgets/image_picker_button.dart'; // Adjust import path as per your project structure

class PreSiteForm extends StatefulWidget {
  final String taskId;
  const PreSiteForm({Key? key, required this.taskId}) : super(key: key);

  @override
  State<PreSiteForm> createState() => _PreSiteFormState();
}

class _PreSiteFormState extends State<PreSiteForm> {
  DateTime? selectedDate;
  String nightActivity = 'Yes';
  String? selectedCircle;
  String? selectedASPName;
  String? selectedScopeOfWork;
  String? selectedActivityType;
  String? selectedVehicle;
  String? selectedStatus;
  List<String> nightActivities = ['Yes', 'No'];
  List<String> circles = ['MH', 'GUJ', 'BR', 'JH', 'ROB', 'UPE', 'UPW'];
  List<String> aspNames = ['ASP 1', 'ASP 2', 'ASP 3'];
  List<String> scopeOfWork = ['11 B', 'CLOT', 'SCFT', 'SSCVT'];
  List<String> activities = ['DT', 'DT+Audit', 'Audit'];
  List<String> vehicles = ['Commercial Cab', 'Private Cab', 'Public Transport'];

  TextEditingController dteName1Controller = TextEditingController();
  TextEditingController dteName2Controller = TextEditingController();
  TextEditingController riggerName1Controller = TextEditingController();
  TextEditingController riggerName2Controller = TextEditingController();
  TextEditingController siteIdController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController driverNameController = TextEditingController();
  TextEditingController drivingLicenseImageController = TextEditingController();
  TextEditingController firstAidImageController = TextEditingController();
  TextEditingController startKmImageController = TextEditingController();
  TextEditingController kmBeforeController = TextEditingController(); // New field
  TextEditingController kmAfterController = TextEditingController(); // New field
  TextEditingController selfieDTERiggerDriverController = TextEditingController();
  TextEditingController kmReadingSiteController = TextEditingController();
  TextEditingController kmReadingSiteReadingController = TextEditingController();
  TextEditingController raOhsStatusController = TextEditingController();
  TextEditingController selfieDTERiggerDriverDriveController = TextEditingController();
  TextEditingController kmReadingDriveCompletionController = TextEditingController();
  TextEditingController kmReadingDriveCompletionReadingController = TextEditingController();
  TextEditingController selfieDTERiggerDriverCompletionController = TextEditingController();
  TextEditingController kmReadingHomeController = TextEditingController();
  TextEditingController dtrAllocatedKmsController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  SiteDataController _controller = Get.put(SiteDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: ListTile(
          title: Text(
            "Pre site form",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Fill the form to proceed"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Is activity planned at night: "),
                          Expanded(
                            child: CustomDropdown<String>(
                              hintText: 'Select Option',
                              items: nightActivities,
                              initialItem: nightActivities[0],
                              onChanged: (value) {
                                setState(() {
                                  nightActivity = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text("Select Circle: "),
                          Expanded(
                            child: CustomDropdown<String>(
                              hintText: 'Select Option',
                              items: circles,
                              initialItem: circles[0],
                              onChanged: (value) {
                                setState(() {
                                  selectedCircle = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text("Select Date: "),
                          InkWell(
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2025),
                              );
                              if (pickedDate != null && pickedDate != selectedDate) {
                                setState(() {
                                  selectedDate = pickedDate;
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(selectedDate != null
                                  ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                                  : "Select Date"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text("Select ASP Name: "),
                          Expanded(
                            child: CustomDropdown<String>(
                              hintText: 'Select ASP Name',
                              items: aspNames,
                              initialItem: aspNames[0],
                              onChanged: (value) {
                                setState(() {
                                  selectedASPName = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text("DTE Name 1: "),
                      TextFormField(
                        controller: dteName1Controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter DTE Name 1',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("DTE Name 2: "),
                      TextFormField(
                        controller: dteName2Controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter DTE Name 2',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Rigger Name 1: "),
                      TextFormField(
                        controller: riggerName1Controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Rigger Name 1',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Rigger Name 2: "),
                      TextFormField(
                        controller: riggerName2Controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Rigger Name 2',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Site ID: "),
                      TextFormField(
                        controller: siteIdController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Site ID',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text("Scope of Work: "),
                          Expanded(
                            child: CustomDropdown<String>(
                              hintText: 'Select Scope of Work',
                              items: scopeOfWork,
                              initialItem: scopeOfWork[0],
                              onChanged: (value) {
                                setState(() {
                                  selectedScopeOfWork = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text("Select Activity Type: "),
                          Expanded(
                            child: CustomDropdown<String>(
                              hintText: 'Select Activity',
                              items: activities,
                              initialItem: activities[0],
                              onChanged: (value) {
                                setState(() {
                                  selectedActivityType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text("Select Vehicle Type: "),
                          Expanded(
                            child: CustomDropdown<String>(
                              hintText: 'Select Vehicle',
                              items: vehicles,
                              initialItem: vehicles[0],
                              onChanged: (value) {
                                setState(() {
                                  selectedVehicle = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text("Vehicle Number: "),
                      TextFormField(
                        controller: vehicleNumberController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Vehicle Number',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Driver Name: "),
                      TextFormField(
                        controller: driverNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Driver Name',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Driving License Image: "),
                      ImagePickerButton(title: "Driving Licence Image", imageKey: "DLimg"),
                      SizedBox(height: 16),
                      Text("First aid / Vehicle Fire extinguisher Pic: "),
                      ImagePickerButton(title: "Upload First Aid / Fire Extinguisher Pic", imageKey: "firstAid"),
                      SizedBox(height: 16),
                      Text("Start Km image from pick up location: "),
                      ImagePickerButton(title: "Start Km image from pick up location", imageKey: "startKm"),
                      SizedBox(height: 16),
                      Text("Start Km reading from pick up location: "),
                      TextFormField(
                        controller: kmBeforeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Start Km Reading',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text("Selfie of DTE with Rigger and Driver in front of Cab showing number Plate from pick up location(In case of public transport, upload selfie from site): "),
                      ImagePickerButton(title: "Upload Photo", imageKey: "Selfie on site"),
                      SizedBox(height: 16),
                      Text("Km reading image just after reaching at site: "),
                      ImagePickerButton(title: "Upload Photo", imageKey: "KM reading on site"),
                      SizedBox(height: 16),
                      Text("Km reading just after reaching at site: "),
                      TextFormField(
                        controller: kmReadingSiteReadingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Km Reading',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text("RA OHS Status: "),
                          Expanded(
                            child: CustomDropdown<String>(
                              hintText: 'Select Scope of Work',
                              items: ['C-OK', 'NA-DT Only', 'OK'],
                              initialItem: "C-OK",
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text("Selfie of DTE with Rigger and Driver during Drive/Audit: "),
                      ImagePickerButton(title: "Upload Selfie", imageKey: "Selfie of DTE with rigger"),
                      SizedBox(height: 16),
                      Text("Km reading image just after drive completion at site: "),
                      ImagePickerButton(title: "Upload Image", imageKey: "KM at site after drive"),
                      SizedBox(height: 16),
                      Text("Km reading just after drive completion at site: "),
                      TextFormField(
                        controller: kmReadingDriveCompletionReadingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Km Reading',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text("Selfie of DTE with Rigger and Driver after drive completion: "),
                      ImagePickerButton(title: "Upload Selfie", imageKey: "Selfie of DTE with rigger adn driver after drive completion"),
                      SizedBox(height: 16),
                      Text("Km reading image on reaching at home: "),
                      ImagePickerButton(title: "Upload Image", imageKey: "Km after reaching home"),
                      SizedBox(height: 16),
                      Text("Km reading on reaching at home: "),
                      TextFormField(
                        controller: kmAfterController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Km Reading',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("DTR Allocated KMs as per BSP: "),
                      TextFormField(
                        controller: dtrAllocatedKmsController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter DTR Allocated KMs',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Remarks (If Any): "),
                      TextFormField(
                        controller: remarksController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Remarks',
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
