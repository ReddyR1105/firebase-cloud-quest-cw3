import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'quest.dart';

String? validateEmail(String? value) =>
    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value?.trim() ?? '')
    ? null
    : 'Enter a valid email address.';

String? validateQuestion(String? value) {
  if (value == null || value.trim().isEmpty) return 'Enter a question.';
  if (value.characters.length > 300) return 'Use at most 300 characters.';
  return null;
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _auth = FirebaseAuth.instance;
  late Stream<User?> _session = _auth.authStateChanges();

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
    stream: _session,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () =>
                  setState(() => _session = _auth.authStateChanges()),
              child: const Text('Session unavailable. Retry'),
            ),
          ),
        );
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final user = snapshot.data;
      return user == null
          ? const SignInScreen()
          : QuestScreen(key: ValueKey(user.uid), user: user);
    },
  );
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    final auth = FirebaseAuth.instance;
    try {
      if (_register) {
        await auth.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text,
        );
      } else {
        await auth.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text,
        );
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      setState(
        () => _error = switch (error.code) {
          'email-already-in-use' => 'That email already has an account.',
          'invalid-credential' ||
          'wrong-password' ||
          'user-not-found' => 'Check your email and password.',
          'weak-password' => 'Choose a password of at least 6 characters.',
          'network-request-failed' =>
            'Connection failed. Check your network and retry.',
          'too-many-requests' => 'Too many attempts. Try again in a moment.',
          _ => 'Authentication failed. Try again.',
        },
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: _Page(
      width: 450,
      children: [
        const _Header(
          'FIREBASE CLOUD QUEST',
          'Signal Check',
          'Sign in to open today’s challenge and track your progress.',
        ),
        const SizedBox(height: 20),
        _Panel(
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _register ? 'Create an account' : 'Welcome back',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  key: const Key('email'),
                  controller: _email,
                  enabled: !_busy,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: validateEmail,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('password'),
                  controller: _password,
                  enabled: !_busy,
                  obscureText: true,
                  onFieldSubmitted: (_) => _submit(),
                  autofillHints: [
                    _register
                        ? AutofillHints.newPassword
                        : AutofillHints.password,
                  ],
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) => (value ?? '').length >= 6
                      ? null
                      : 'Enter at least 6 characters.',
                ),
                if (_error != null) _Message(_error!, error: true),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _busy ? null : _submit,
                  child: Text(
                    _busy
                        ? 'Please wait…'
                        : _register
                        ? 'Register'
                        : 'Sign in',
                  ),
                ),
                if (_busy) const LinearProgressIndicator(),
                TextButton(
                  onPressed: _busy
                      ? null
                      : () {
                          _form.currentState!.reset();
                          _password.clear();
                          setState(() {
                            _register = !_register;
                            _error = null;
                          });
                        },
                  child: Text(
                    _register ? 'Back to sign in' : 'Create an account',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key, required this.user});
  final User user;

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  final _service = QuestService();
  final _question = TextEditingController();
  final _coachForm = GlobalKey<FormState>();
  late Stream<DailyChallenge?> _challenge = _service.challenge();
  late Stream<QuestProgress> _progress = _service.progress(widget.user.uid);
  bool _completing = false;
  bool _asking = false;
  bool _signingOut = false;
  String? _completion;
  bool _completionError = false;
  String? _signOutError;
  String? _coachError;
  ({String hint, String source})? _reply;

  @override
  void dispose() {
    _question.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    setState(() {
      _signingOut = true;
      _signOutError = null;
    });
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException {
      if (mounted) {
        setState(() => _signOutError = 'Sign-out failed. Try again.');
      }
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  Future<void> _complete() async {
    setState(() {
      _completing = true;
      _completion = null;
      _completionError = false;
    });
    try {
      final repeated = await _service.complete();
      if (mounted) {
        setState(
          () => _completion = repeated
              ? 'Already completed. Your reward is unchanged.'
              : 'Challenge complete. You earned 10 points and the First Quest badge.',
        );
      }
    } on FirebaseFunctionsException catch (error) {
      if (mounted) {
        setState(() {
          _completion = switch (error.code) {
            'failed-precondition' when error.message != null => error.message!,
            'unauthenticated' => 'Sign in again before recording completion.',
            _ => 'Completion could not be checked. Try again.',
          };
          _completionError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _completing = false);
    }
  }

  Future<void> _ask() async {
    if (_asking || !_coachForm.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _asking = true;
      _reply = null;
      _coachError = null;
    });
    try {
      final reply = await _service.ask(_question.text);
      if (mounted) setState(() => _reply = reply);
    } on FirebaseFunctionsException catch (error) {
      if (mounted) {
        setState(
          () => _coachError = switch (error.code) {
            'failed-precondition' ||
            'invalid-argument' when error.message != null => error.message!,
            'unauthenticated' => 'Sign in again to ask Quest Coach.',
            _ => 'Quest Coach is unavailable. Try again later.',
          },
        );
      }
    } finally {
      if (mounted) setState(() => _asking = false);
    }
  }

  Widget _dailyChallenge(AsyncSnapshot<DailyChallenge?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LinearProgressIndicator();
    }
    final challenge = snapshot.data;
    if (challenge == null || snapshot.hasError) {
      return _Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              snapshot.hasError
                  ? 'Challenge could not load.'
                  : 'No challenge is available today.',
            ),
            TextButton(
              onPressed: () =>
                  setState(() => _challenge = _service.challenge()),
              child: const Text('Retry challenge'),
            ),
          ],
        ),
      );
    }
    return _Header('DAILY CHALLENGE', challenge.title, challenge.prompt);
  }

  Widget _progressPanel(bool challengeAvailable) => _Panel(
    child: StreamBuilder<QuestProgress>(
      stream: _progress,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return TextButton(
            onPressed: () =>
                setState(() => _progress = _service.progress(widget.user.uid)),
            child: const Text('Progress unavailable. Retry'),
          );
        }
        final progress = snapshot.data;
        if (progress == null) return const LinearProgressIndicator();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(
                  avatar: const Icon(Icons.bolt_outlined),
                  label: Text('${progress.points} points'),
                ),
                Chip(
                  avatar: Icon(
                    progress.completed
                        ? Icons.workspace_premium_outlined
                        : Icons.lock_outline,
                  ),
                  label: Text('Badge: ${progress.badge}'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              progress.completed
                  ? 'Completed'
                  : challengeAvailable
                  ? 'Ready to complete'
                  : 'Waiting for today’s challenge',
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed:
                  _completing || (!challengeAvailable && !progress.completed)
                  ? null
                  : _complete,
              icon: const Icon(Icons.check_circle_outline),
              label: Text(
                _completing
                    ? 'Checking…'
                    : progress.completed
                    ? 'Check completion'
                    : 'Complete Challenge',
              ),
            ),
            if (_completing) const LinearProgressIndicator(),
            if (_completion != null)
              _Message(_completion!, error: _completionError),
          ],
        );
      },
    ),
  );

  Widget _coachPanel(bool challengeAvailable) => _Panel(
    child: Form(
      key: _coachForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Quest Coach', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          TextFormField(
            key: const Key('question'),
            controller: _question,
            maxLength: 300,
            minLines: 2,
            maxLines: 4,
            enabled: challengeAvailable && !_asking,
            decoration: const InputDecoration(
              labelText: 'What would you like a hint about?',
            ),
            validator: validateQuestion,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.tonalIcon(
              onPressed: _asking || !challengeAvailable ? null : _ask,
              icon: const Icon(Icons.lightbulb_outline),
              label: Text(_asking ? 'Getting hint…' : 'Get Hint'),
            ),
          ),
          if (_asking) const LinearProgressIndicator(),
          if (_coachError != null) _Message(_coachError!, error: true),
          if (_reply case final reply?) ...[
            _Message(reply.hint),
            if (reply.source == 'local-grounded')
              const Text('Local emulator hint'),
          ],
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Signal Check'),
      actions: [
        TextButton.icon(
          onPressed: _signingOut ? null : _signOut,
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: StreamBuilder<DailyChallenge?>(
      stream: _challenge,
      builder: (context, snapshot) {
        final available =
            snapshot.connectionState != ConnectionState.waiting &&
            snapshot.hasData &&
            !snapshot.hasError;
        return _Page(
          width: 660,
          children: [
            if (_signOutError != null) _Message(_signOutError!, error: true),
            _dailyChallenge(snapshot),
            const SizedBox(height: 16),
            _progressPanel(available),
            const SizedBox(height: 16),
            _coachPanel(available),
          ],
        );
      },
    ),
  );
}

class _Page extends StatelessWidget {
  const _Page({required this.width, required this.children});
  final double width;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    ),
  );
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Padding(padding: const EdgeInsets.all(20), child: child),
  );
}

class _Header extends StatelessWidget {
  const _Header(this.label, this.title, this.subtitle);
  final String label;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xff193c34),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.sensors, color: Color(0xffd6ecac), size: 36),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xffd6ecac),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xffe1ece5), height: 1.45),
          ),
        ],
      ),
    ),
  );
}

class _Message extends StatelessWidget {
  const _Message(this.text, {this.error = false});
  final String text;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Semantics(
        liveRegion: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: error ? colors.errorContainer : colors.secondaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              text,
              style: TextStyle(
                color: error
                    ? colors.onErrorContainer
                    : colors.onSecondaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
