import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/widgets/custom_button.dart';
import 'package:green_bin/widgets/error_message_text.dart';

import '../../providers/user_provider.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/back_button.dart';
import '../../widgets/cust_form_field.dart';

class UpdateUsernamePage extends ConsumerStatefulWidget {
  static String routeName = "/update-username";

  const UpdateUsernamePage({super.key});

  @override
  ConsumerState<UpdateUsernamePage> createState() => _UpdateUsernamePageState();
}

class _UpdateUsernamePageState extends ConsumerState<UpdateUsernamePage> {
  final TextEditingController _usernameController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userAsyncValue = ref.read(currentUserProvider);
      userAsyncValue.whenData((user) {
        if (user != null) {
          _usernameController.text = user.username ?? '';
        }
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: CustBackButton(),
      ),

      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _mainBody(),
    );
  }

  Widget _mainBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Username',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 32,
              fontFamily: 'Poppins',
            ),
          ),

          SizedBox(height: 40),

          CustFormField(
            controller: _usernameController,
            keyboardType: TextInputType.text,
            hintText: 'New Username',
            isPassword: false,
          ),

          const SizedBox(height: 20.0),

          ErrorMessageText(errorMessage: _errorMessage),

          SizedBox(height: 40),

          CustomButton(
            buttonText: "Update Username",
            onPressed: updateUsername,
          ),
        ],
      ),
    );
  }

  void updateUsername() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    User? currentUser = authService.value.currentUser;
    if (currentUser == null) return;

    try {
      final userProfileService = ref.read(userProfileServiceProvider);

      final newUsername = _usernameController.text;
      await userProfileService.updateUserData(
        newUsername: _usernameController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile updated successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        Navigator.pop(context);
      }

      await authService.value.updateUsername(newUsername);
      await currentUser.reload();
      currentUser = authService.value.currentUser;

      await DatabaseService().updateUsername(newUsername);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

}
