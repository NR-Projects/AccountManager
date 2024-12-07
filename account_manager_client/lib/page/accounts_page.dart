import 'package:flutter/material.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  List<Map<String, String>> accounts = [
    {"site": "Google", "label": "Personal", "email": "user@gmail.com", "password": "password123"},
    {"site": "GitHub", "label": "Work", "email": "dev@github.com", "password": "securePass456"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
    {"site": "Flutter", "label": "Learning", "email": "learn@flutter.dev", "password": "flutterRocks"},
  ];

  List<Map<String, String>> filteredAccounts = [];
  List<String> sites = ["Google", "GitHub", "Flutter"];
  String selectedSite = "All";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredAccounts = accounts;
  }

  void filterAccounts() {
    setState(() {
      filteredAccounts = accounts.where((account) {
        final matchesSite = selectedSite == "All" || account["site"] == selectedSite;
        final matchesSearch = account["label"]!.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesSite && matchesSearch;
      }).toList();
    });
  }

  void addAccount(String site, String label, String email, String password) {
    setState(() {
      accounts.add({"site": site, "label": label, "email": email, "password": password});
      filterAccounts();
    });
  }

  void updateAccount(int index, String site, String label, String email, String password) {
    setState(() {
      accounts[index] = {"site": site, "label": label, "email": email, "password": password};
      filterAccounts();
    });
  }

  void deleteAccount(int index) {
    setState(() {
      accounts.removeAt(index);
      filterAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accounts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddOrUpdateAccountDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: selectedSite,
                  items: ["All", ...sites]
                      .map((site) => DropdownMenuItem(value: site, child: Text(site)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSite = value!;
                      filterAccounts();
                    });
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search by label",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        filterAccounts();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Table(
                  border: TableBorder.all(color: Colors.grey),
                  columnWidths: const {
                    0: FlexColumnWidth(4), // (Site) Label
                    1: FlexColumnWidth(2), // Actions
                  },
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(color: Colors.blueGrey),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("(Site) Label",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Actions",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ],
                    ),
                    for (int index = 0; index < filteredAccounts.length; index++)
                      TableRow(
                        children: [
                          InkWell(
                            onTap: () => _showAccountDetails(context, filteredAccounts[index]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "(${filteredAccounts[index]['site']}) ${filteredAccounts[index]['label']}",
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => _showAddOrUpdateAccountDialog(context, index: index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteAccount(index),
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
        ],
      ),
    );
  }

  void _showAddOrUpdateAccountDialog(BuildContext context, {int? index}) {
    final isEditing = index != null;
    final TextEditingController siteController = TextEditingController(
      text: isEditing ? accounts[index]["site"] : "",
    );
    final TextEditingController labelController = TextEditingController(
      text: isEditing ? accounts[index]["label"] : "",
    );
    final TextEditingController emailController = TextEditingController(
      text: isEditing ? accounts[index]["email"] : "",
    );
    final TextEditingController passwordController = TextEditingController(
      text: isEditing ? accounts[index]["password"] : "",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? "Update Account" : "Add Account"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: siteController, decoration: const InputDecoration(labelText: "Site")),
              TextField(controller: labelController, decoration: const InputDecoration(labelText: "Label")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password")),
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
                final site = siteController.text.trim();
                final label = labelController.text.trim();
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                if (site.isNotEmpty && label.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
                  if (isEditing) {
                    updateAccount(index, site, label, email, password);
                  } else {
                    addAccount(site, label, email, password);
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

  void _showAccountDetails(BuildContext context, Map<String, String> account) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Account Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Site: ${account['site']}"),
              Text("Label: ${account['label']}"),
              Text("Email: ${account['email']}"),
              Text("Password: ${account['password']}"),
            ],
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
