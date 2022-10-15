import 'package:flutter/material.dart';
import 'package:social_auth/social_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen()
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> _signInWithGithub() async {
    GitHubSignInHelper gitHubSignInHelper = GitHubSignInHelper(
      clientId: "84fd07a806476b43e1bd",
      clientSecret: "e494aa6a0d92447374a8c695e47f69aa250964fc",
      redirectUrl: "http://louismidson.me",
    );

    try{
      SocialAuthUser user = await gitHubSignInHelper.signIn(context);
      signIn(user);
    } on AuthenticationCanceled catch(e){
      // ignore: avoid_print
      print(e.message);
    } on AuthenticationError catch(e){
      // ignore: avoid_print
      print("Errors : ${e.errors}");
    }
  }

  Future<void> _signInWithGoogle() async {
    GoogleSignInHelper googleSignInHelper = GoogleSignInHelper();
    try{
      SocialAuthUser user = await googleSignInHelper.signIn();
      signIn(user);
    } on AuthenticationCanceled catch(e){
      // ignore: avoid_print
      print(e.message);
    } on AuthenticationError catch(e){
      // ignore: avoid_print
      print("Errors : ${e.errors}");
    }
  }

  void signIn(SocialAuthUser user){
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(user: user)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Auth Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Sign in with GitHub'),
              onPressed: () => _signInWithGithub(),
            ),
            ElevatedButton(
              child: const Text('Sign in with Google'),
              onPressed: () => _signInWithGoogle(),
            ),
          ]
        )
      )
    );
  }
}


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});

  final SocialAuthUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(user.profileUrl)
                )
              ),
            ),
            const SizedBox(height: 20),
            Text(user.fullname, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text(user.email ?? "Unknown", style: const TextStyle(fontSize: 16)),
          ]
        )
      )
    );
  }
}