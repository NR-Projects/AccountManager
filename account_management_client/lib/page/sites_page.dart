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
    _loadSites();
  }

  Future<void> _loadSites() async {
    final fetchedSites = await widget.siteService.getAllSites();
    setState(() {
      sites = fetchedSites;
    });
  }

  void _showSiteDetails(Site site) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(site.name),
        content: Text('Link: ${site.link}\n\nAdditional details...'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editSite(Site site) {
    TextEditingController nameController = TextEditingController(text: site.name);
    TextEditingController linkController = TextEditingController(text: site.link);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Site'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Site Name'),
            ),
            TextField(
              controller: linkController,
              decoration: const InputDecoration(labelText: 'Site Link'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final updatedSite = Site(
                id: site.id,
                name: nameController.text,
                link: linkController.text,
              );
              await widget.siteService.updateExistingSite(updatedSite);
              _loadSites();
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteSite(String siteId) async {
    await widget.siteService.deleteExistingSite(siteId);
    _loadSites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sites'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadSites,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: sites.length,
          itemBuilder: (context, index) => siteItemCard(sites[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController nameController = TextEditingController();
          TextEditingController linkController = TextEditingController();

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Add New Site'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Site Name'),
                  ),
                  TextField(
                    controller: linkController,
                    decoration: const InputDecoration(labelText: 'Site Link'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final newSite = Site(
                      id: UniqueKey().toString(),
                      name: nameController.text,
                      link: linkController.text,
                    );
                    await widget.siteService.addNewSite(newSite);
                    _loadSites();
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget siteItemCard(Site site) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        title: Text(
          site.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Link: ${site.link}'),
        leading: const Icon(Icons.link, color: Colors.blue),
        onTap: () => _showSiteDetails(site),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Edit') _editSite(site);
            if (value == 'Delete') _deleteSite(site.id);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'Edit', child: Text('Edit')),
            const PopupMenuItem(value: 'Delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
