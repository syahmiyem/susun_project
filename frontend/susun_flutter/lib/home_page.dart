import 'package:flutter/material.dart';
import 'api_service.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  // The token is passed to this screen after login.
  final String token;
  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggingOut = false;
  String? _errorMessage;

  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
      _errorMessage = null;
    });

    try {
      final success = await ApiService.logout(widget.token);
      setState(() {
        _isLoggingOut = false;
      });
      // If the logout call returns true, navigate to LoginPage.
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        setState(() {
          _errorMessage = "Logout failed. Please try again.";
        });
      }
    } catch (e) {
      // If an exception occurs, check if it indicates a 403 error.
      if (e.toString().contains("403")) {
        // Treat a 403 as a successful logout.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        setState(() {
          _isLoggingOut = false;
          _errorMessage = "Logout failed: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Susun"),
        actions: [
          // Logout button in the AppBar
          IconButton(
            icon: _isLoggingOut
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                : const Icon(Icons.logout),
            onPressed: _isLoggingOut ? null : _handleLogout,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Welcome to Susun",
              style: TextStyle(fontSize: 24),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 20),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
