import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/back_button.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/form/error_message_text.dart';
import '../../widgets/form/cust_form_field.dart';

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

  Widget _mainBody() => Padding(
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
        ),
        const SizedBox(height: 20.0),

        ErrorMessageText(errorMessage: _errorMessage),
        SizedBox(height: 40),

        CustomButton(buttonText: "Update Username", onPressed: updateUsername),
      ],
    ),
  );

  void updateUsername() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Validate if username text is empty
      if (_usernameController.text.trim().isEmpty) {
        setState(() {
          _errorMessage = 'Username cannot be empty';
        });
        return;
      }

      final authService = ref.read(authServiceProvider);
      await authService.updateUsername(_usernameController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profile updated successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
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
