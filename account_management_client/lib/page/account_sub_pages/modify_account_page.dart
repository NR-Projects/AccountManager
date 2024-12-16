import 'package:account_management_client/model/entity/account.dart';
import 'package:account_management_client/service/account_service.dart';
import 'package:flutter/material.dart';

class ModifyAccountPage extends StatefulWidget {
  final List<Account> currentAccountList;
  final List<String> currentSiteNames;
  final AccountService accountService;
  final Account? account;

  const ModifyAccountPage({
    super.key,
    required this.currentAccountList,
    required this.currentSiteNames,
    required this.accountService,
    this.account,
  });

  @override
  State<ModifyAccountPage> createState() => _ModifyAccountPageState();
}

class _ModifyAccountPageState extends State<ModifyAccountPage> {
  bool isEdit = false;
  Account account = Account.initEmpty();

  @override
  void initState() {
    super.initState();

    // Determine if add or edit
    isEdit = widget.account != null;

    // Create account from isEdit
    account = isEdit ? widget.account! : account;
  }

  void _saveAccount(Account account) {
    if (isEdit) {
      widget.accountService.updateAccount(account);
    } else {
      widget.accountService.createAccount(account);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Account' : 'Add Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: _buildAccountModifyDetailsView(account),
        ),
      ),
    );
  }

  Widget _buildAccountModifyDetailsView(Account account) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account ID
        Text(
          'ID: ${isEdit ? account.id : "<NEW ACCOUNT>"}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),

        // Account Type Dropdown
        DropdownButtonFormField<String>(
          value: account.accountType,
          items: const [
            DropdownMenuItem(
              value: 'USERNAME_PASSWORD',
              child: Text('Username + Password'),
            ),
            DropdownMenuItem(
              value: 'LINKED',
              child: Text('Linked'),
            ),
            DropdownMenuItem(
              value: 'PASSWORD_ONLY',
              child: Text('Password-Only'),
            ),
          ],
          onChanged: (value) => setState(() {
            account.accountType = value!;
          }),
          decoration: const InputDecoration(labelText: 'Account Type'),
        ),

        const SizedBox(height: 16),

        // Label Input
        TextField(
          decoration: const InputDecoration(labelText: 'Label'),
          onChanged: (val) => account.label = val,
          controller: TextEditingController(text: account.label),
        ),

        const SizedBox(height: 16),

        // Site Dropdown
        DropdownButtonFormField<String>(
          value: account.siteName.isNotEmpty
              ? account.siteName
              : null, // Set to null if empty
          items: widget.currentSiteNames.map((site) {
            return DropdownMenuItem<String>(
              value: site,
              child: Text(site),
            );
          }).toList(),
          onChanged: (val) => setState(() => account.siteName = val!),
          decoration: const InputDecoration(labelText: 'Site'),
        ),

        const SizedBox(height: 16),

        // Username + Password Fields
        if (account.accountType == 'USERNAME_PASSWORD') ...[
          TextField(
            decoration: const InputDecoration(labelText: 'Username'),
            onChanged: (val) => account.username = val,
            controller: TextEditingController(text: account.username),
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onChanged: (val) => account.password = val,
            controller: TextEditingController(text: account.password),
          ),
        ],

        // Linked Account Dropdown
        if (account.accountType == 'LINKED') ...[
          DropdownButtonFormField<String>(
            value: (widget.currentAccountList
                    .any((acc) => acc.id == account.linkedAccountId))
                ? account.linkedAccountId
                : null,
            items: widget.currentAccountList.map((acc) {
              return DropdownMenuItem<String>(
                value: acc.id,
                child: Text(acc.label),
              );
            }).toList(),
            onChanged: (val) => setState(() => account.linkedAccountId = val!),
            decoration: const InputDecoration(labelText: 'Linked Account'),
          ),
        ],

        // Password Fields
        if (account.accountType == 'PASSWORD_ONLY') ...[
          TextField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onChanged: (val) => account.password = val,
            controller: TextEditingController(text: account.password),
          ),
        ],

        const SizedBox(height: 16),

        // Notes Field
        TextField(
          decoration: const InputDecoration(labelText: 'Notes'),
          onChanged: (val) => account.notes = val,
          controller: TextEditingController(text: account.notes),
          maxLines: 3,
        ),

        const SizedBox(height: 24),

        // Save Button
        ElevatedButton(
          onPressed: () => {_saveAccount(account)},
          child: const Text('Save'),
        ),
      ],
    );
  }
}
