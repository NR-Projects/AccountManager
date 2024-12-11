import 'package:account_management_client/model/entity/site.dart';
import 'package:account_management_client/service/site_service.dart';
import 'package:flutter/material.dart';

class SitesPage extends StatefulWidget {
  final SiteService siteService;

  const SitesPage({super.key, required this.siteService});

  @override
  State<SitesPage> createState() => _SitesPageState();
}

class _SitesPageState extends State<SitesPage> {
  List<Site> sites = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    final fetchedSites = await widget.siteService.getAllSites();
    //print(fetchedSites[0].id);
    setState(() {
      sites = fetchedSites;
    });
  }

  // Add a new Site object
  Future<void> addSite(String name, String link) async {
    await widget.siteService
        .addNewSite(Site(id: UniqueKey().toString(), name: name, link: link));
    await initializeData();
  }

  // Update an existing Site object
  Future<void> updateSite(int index, String name, String link) async {
    await widget.siteService
        .updateExistingSite(Site(id: sites[index].id, name: name, link: link));
    await initializeData();
  }

  // Remove a site
  Future<void> removeSite(int index) async {
    await widget.siteService.deleteExistingSite(sites[index].id);
    await initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sites"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddOrUpdateSiteDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(3), // Site name
                1: FlexColumnWidth(2), // Actions
              },
              children: [
                // Table header
                const TableRow(
                  decoration: BoxDecoration(color: Colors.blueGrey),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Site Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Actions",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                // Table rows with data
                for (int index = 0; index < sites.length; index++)
                  TableRow(
                    children: [
                      GestureDetector(
                        onTap: () => _showSiteDetailsDialog(
                          context,
                          sites[index].name,
                          sites[index].link,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            sites[index].name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showAddOrUpdateSiteDialog(context,
                                index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async => await removeSite(index),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show a dialog to add or update a site
  void _showAddOrUpdateSiteDialog(BuildContext context, {int? index}) {
    final isEditing = index != null;
    final TextEditingController nameController = TextEditingController(
      text: isEditing ? sites[index].name : "",
    );
    final TextEditingController linkController = TextEditingController(
      text: isEditing ? sites[index].link : "",
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? "Update Site" : "Add Site"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Site Name"),
              ),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(labelText: "Site Link"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(isEditing ? "Update" : "Add"),
              onPressed: () {
                final name = nameController.text.trim();
                final link = linkController.text.trim();
                if (name.isNotEmpty) {
                  if (isEditing) {
                    updateSite(index, name, link);
                  } else {
                    addSite(name, link);
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Show a dialog with site details
  void _showSiteDetailsDialog(
      BuildContext context, String? name, String? link) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name ?? "Site Details"),
          content: SelectableText(
            link ?? "No link available",
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
