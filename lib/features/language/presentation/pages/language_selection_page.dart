import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/language_bloc.dart';
import '../bloc/language_event.dart';
import '../bloc/language_state.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({Key? key}) : super(key: key);

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  @override
  void initState() {
    super.initState();
    context.read<LanguageBloc>().add(LoadAvailableLanguages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Language'),
      ),
      body: BlocConsumer<LanguageBloc, LanguageState>(
        listener: (context, state) {
          if (state is LanguageSelected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${state.language.name} selected!')),
            );
            Navigator.pop(context);
          } else if (state is LanguageError) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is LanguageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LanguagesLoaded) {
            return ListView.builder(
              itemCount: state.languages.length,
              itemBuilder: (context, index) {
                final language = state.languages[index];
                return ListTile(
                  title: Text(language.name),
                  onTap: () {
                    context.read<LanguageBloc>().add(SelectLanguage(language));
                  },
                );
              },
            );
          }
          return const Center(child: Text('Select a language to get started.'));
        },
      ),
    );
  }
}