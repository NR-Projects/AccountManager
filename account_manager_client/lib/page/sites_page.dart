import 'package:flutter/material.dart';

class SitesPage extends StatefulWidget {
  const SitesPage({super.key});

  @override
  State<SitesPage> createState() => _SitesPageState();
}

class _SitesPageState extends State<SitesPage> {
  // List of sites with name and link
  List<Map<String, String>> sites = [
    {"name": "Google", "link": "https://www.google.com"},
    {"name": "Flutter", "link": "https://flutter.dev"},
    {"name": "GitHub", "link": "https://github.com"},
    {"name": "Stack Overflow", "link": "https://stackoverflow.com"},
  ];

  // Function to add a new site
  void addSite(String name) {
    setState(() {
      sites.add({"name": name, "link": ""});
    });
  }

  // Function to update an existing site
  void updateSite(int index, String name, String link) {
    setState(() {
      sites[index] = {"name": name, "link": link};
    });
  }

  // Function to remove a site by index
  void removeSite(int index) {
    setState(() {
      sites.removeAt(index);
    });
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
                const TableRow(
                  decoration: BoxDecoration(color: Colors.blueGrey),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Site Name",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Actions",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                for (int index = 0; index < sites.length; index++)
                  TableRow(
                    children: [
                      GestureDetector(
                        onTap: () => _showSiteDetailsDialog(context, sites[index]["name"], sites[index]["link"]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            sites[index]["name"]!,
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
                            onPressed: () => _showAddOrUpdateSiteDialog(context, index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeSite(index),
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
      text: isEditing ? sites[index]["name"] : "",
    );
    final TextEditingController linkController = TextEditingController(
      text: isEditing ? sites[index]["link"] : "",
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
              onPressed: () {
                Navigator.of(context).pop();
              },
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
                    addSite(name);
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

  // Show a dialog for site details
  void _showSiteDetailsDialog(BuildContext context, String? name, String? link) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name ?? "Site Details"),
          content: SelectableText(
            link ?? "No link available",
            style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
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
