import 'package:account_management_client/model/entity/account.dart';
import 'package:account_management_client/service/account_service.dart';
import 'package:flutter/material.dart';

class ViewAccountPage extends StatelessWidget {
  final Account account;
  final List<Account> currentAccountList;
  final AccountService accountService;

  const ViewAccountPage({
    super.key,
    required this.account,
    required this.currentAccountList,
    required this.accountService,
  });

  Future<void> _showPassword(BuildContext context, String accountId) async {
    final password = await accountService.getPassword(accountId);
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Password'),
        content: Text(password),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Builds the link path and retrieves the final account
  Map<String, dynamic> _buildLinkPathAndFinalAccount(Account account) {
    List<String> path = [];
    Account? current = account;

    while (current?.accountType == 'LINKED' && current?.linkedAccountId != null) {
      path.add(current!.label);
      current = currentAccountList
          .firstWhere((acc) => acc.id == current!.linkedAccountId);
    }

    if (current != null) path.add(current.label);

    return {'linkPath': path, 'finalAccount': current};
  }

  @override
  Widget build(BuildContext context) {
    final result = _buildLinkPathAndFinalAccount(account);
    final List<String> linkPath = result['linkPath'];
    final Account? finalAccount = result['finalAccount'];

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account Details',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                ),
                const Divider(height: 24, color: Colors.white),

                // Default Account Information
                _buildCompactListTile(title: "ID", value: account.id),
                _buildCompactListTile(title: "Label", value: account.label),
                _buildCompactListTile(title: "Site", value: account.siteName),
                _buildCompactListTile(title: "Notes", value: account.notes),

                // Link Path
                if (linkPath.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildCompactListTile(
                    title: "Link Path",
                    value: linkPath.join(" -> "),
                  ),
                ],

                // Specific Account Information
                if (finalAccount != null) ...[
                  const SizedBox(height: 16),
                  _buildSectionTitle("Specific Account Information"),
                  _buildAccountSpecificDetails(context, finalAccount),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// A widget for title-value pairs with compact spacing
  Widget _buildCompactListTile({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduced vertical padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Fixed width for titles
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the account-specific details
  Widget _buildAccountSpecificDetails(BuildContext context, Account finalAccount) {
    switch (finalAccount.accountType) {
      case 'USERNAME_PASSWORD':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCompactListTile(
              title: "Username",
              value: finalAccount.username ?? "N/A",
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showPassword(context, finalAccount.id),
              icon: const Icon(Icons.lock),
              label: const Text('Show Password'),
            ),
          ],
        );

      case 'PASSWORD_ONLY':
        return ElevatedButton.icon(
          onPressed: () => _showPassword(context, finalAccount.id),
          icon: const Icon(Icons.visibility),
          label: const Text('Show Password'),
        );

      default:
        return const Text(
          "No Account Type Implementation Yet",
          style: TextStyle(color: Colors.red),
        );
    }
  }

  /// Section title for better readability
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
