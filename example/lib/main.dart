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
      clientId: "YOUR_CLIENT_ID",
      clientSecret: "YOUR_CLIENT_SECRET",
      redirectUrl: "YOUR_REDIRECT_URL",
    );

    try{
      SocialAuthUser user = await gitHubSignInHelper.signIn(context);
      jumpToProfilePage(user);
    }catch(e){
      // ignore: avoid_print
      print(e.toString());
    }
  }

  void jumpToProfilePage(SocialAuthUser user){
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
            Text(user.email),
          ]
        )
      )
    );
  }
}