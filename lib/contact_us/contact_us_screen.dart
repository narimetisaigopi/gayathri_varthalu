import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gayathri_varthalu/bottom_nav_bloc.dart';
import 'package:gayathri_varthalu/contact_us/contact_us_service.dart';
import 'package:gayathri_varthalu/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  final bool visible;
  const ContactUsScreen({super.key, this.visible = false});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  Map<String, dynamic>? contactData;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _fetchContactData();
  }

  Future<void> _fetchContactData() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      final data = await ContactUsService().fetchContactUsData();
      setState(() {
        contactData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.read<BottomNavBloc>().add(const TabChanged(0));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.primaryColor,
            title: const Text('Contact Us',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : isError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Failed to load contact info.'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchContactData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : contactData == null
                      ? const Center(child: Text('No contact info available.'))
                      : Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              if (contactData?['result'][0]['email'] !=
                                  null) ...[
                                const Text(
                                  'Email:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                SelectableText(
                                  contactData?['result'][0]['email'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 16),
                              ],
                              const Text(
                                'Address',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                contactData?['result'][0]['address'],
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              SelectableText(
                                "${contactData?['result'][0]['mobile']}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                                onTap: () async {
                                  final phone =
                                      "+${contactData?['result'][0]['mobile']}" ??
                                          '+91 98765 43210';
                                  final uri = Uri(scheme: 'tel', path: phone);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  }
                                },
                              )
                            ],
                          ),
                        ),
        ),
      ),
    );
  }
}
