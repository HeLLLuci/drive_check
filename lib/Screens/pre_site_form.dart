import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:drive_check/controller/pre_site_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import '../controller/pre_site_image_picker.dart';

class PreSiteForm extends StatefulWidget {
  final String taskId;
  const PreSiteForm({Key? key, required this.taskId}) : super(key: key);

  @override
  State<PreSiteForm> createState() => _PreSiteFormState();
}

class _PreSiteFormState extends State<PreSiteForm> {
  final List<String> imageKeys = ["DLimg", "firstAid", "startKm", "Selfie from room", "Selfie of DTE with rigger", "Selfie with cab", "Cab RC Photo", "Insurance documents image", "No. Plate of cab", "Handset with holder", "Photo of PPE kit equipments"];
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

  PreSiteFormController _controller = Get.put(PreSiteFormController());

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
                color: Colors.white,
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
                                  _controller.date.value = pickedDate.toString();
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
                color: Colors.white,
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
                        controller: _controller.dteName1Controller,
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
                        controller: _controller.dteName2Controller,
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
                        controller: _controller.riggerName1Controller,
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
                        controller: _controller.riggerName2Controller,
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
                        controller: _controller.siteIdController,
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
                color: Colors.white,
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
                color: Colors.white,
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
                        controller: _controller.vehicleNumberController,
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
                        controller: _controller.driverNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Driver Name',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Driving License Image: "),
                      PreSiteImagePickerButton(title: "Driving Licence Image", imageKey: imageKeys[0]),
                      SizedBox(height: 16),
                      Text("First aid / Vehicle Fire extinguisher Pic: "),
                      PreSiteImagePickerButton(title: "Upload First Aid / Fire Extinguisher Pic", imageKey: imageKeys[1]),
                      SizedBox(height: 16),
                      Text("Start Km image from pick up location: "),
                      PreSiteImagePickerButton(title: "Start Km image from pick up location", imageKey: imageKeys[2]),
                      SizedBox(height: 16),
                      Text("Start Km reading from pick up location: "),
                      TextFormField(
                        controller: _controller.kmBeforeController,
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
                color: Colors.white,
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text("Selfie of DTE with Rigger and Driver in front of Cab showing number Plate from pick up location(In case of public transport, upload selfie from site): "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[3]),
                      SizedBox(height: 16),
                      Text("${imageKeys[4]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[4]),
                      SizedBox(height: 16),
                      Text("${imageKeys[5]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[5]),
                      SizedBox(height: 16),
                      Text("${imageKeys[6]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[6]),
                      SizedBox(height: 16),
                      Text("${imageKeys[7]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[7]),
                      SizedBox(height: 16),
                      Text("${imageKeys[8]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[8]),
                      SizedBox(height: 16),
                      Text("${imageKeys[9]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[9]),
                      SizedBox(height: 16),
                      Text("${imageKeys[10]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[10]),
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.white,
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
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text("DTR Allocated KMs as per BSP: "),
                      TextFormField(
                        controller: _controller.dtrAllocatedKmsController,
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
                        controller: _controller.remarksController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Remarks',
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(onPressed: (){
                        OverlayLoadingProgress.start(context,
                          widget: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Lottie.asset("assets/Animations/loading.json"),
                            ),
                          ),
                        );
                        _controller.uploadImageAndData("preSite", imageKeys, "PreSiteData", widget.taskId, selectedDate.toString());
                      }, child: Text("Submit"))
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
