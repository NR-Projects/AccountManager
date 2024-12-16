import 'package:account_management_client/model/dto/accounts_and_sites.dart';
import 'package:account_management_client/model/entity/account.dart';
import 'package:account_management_client/page/account_sub_pages/modify_account_page.dart';
import 'package:account_management_client/page/account_sub_pages/view_account_page.dart';
import 'package:account_management_client/service/account_service.dart';
import 'package:flutter/material.dart';

class AccountsPage extends StatefulWidget {
  final AccountService accountService;

  const AccountsPage({super.key, required this.accountService});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  AccountsAndSites accountsAndSites = AccountsAndSites.initEmpty();

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final fetchedAccountsAndSites = await widget.accountService.getAllAccountsAndSites();
    setState(() {
      accountsAndSites = fetchedAccountsAndSites;
    });
  }

  void _showAccountDetails(Account account) async {
    showDialog(
      context: context,
      builder: (_) => ViewAccountPage(
        account: account,
        currentAccountList: accountsAndSites.accounts,
        accountService: widget.accountService,
      ),
    );
  }

  void _editAccount(Account account) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ModifyAccountPage(
          accountService: widget.accountService,
          account: account,
          currentAccountList: accountsAndSites.accounts,
          currentSiteNames: accountsAndSites.siteNames,
        ),
      ),
    ).then((_) => _loadAccounts());
  }

  void _deleteAccount(String accountId) async {
    await widget.accountService.deleteAccount(accountId);
    _loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadAccounts,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: accountsAndSites.accounts.length,
          itemBuilder: (context, index) => accountItemCard(accountsAndSites.accounts[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ModifyAccountPage(
                accountService: widget.accountService,
                currentAccountList: accountsAndSites.accounts,
                currentSiteNames: accountsAndSites.siteNames,
              ),
            ),
          ).then((_) => _loadAccounts());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget accountItemCard(Account account) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        title: Text(account.label,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Site: ${account.siteName}'),
        leading: const Icon(Icons.account_circle, color: Colors.blue),
        onTap: () => _showAccountDetails(account),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Edit') _editAccount(account);
            if (value == 'Delete') _deleteAccount(account.id);
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
