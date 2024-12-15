import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityInsightsPage extends StatefulWidget {
  const CommunityInsightsPage({super.key});

  @override
  State<CommunityInsightsPage> createState() => _CommunityInsightsPageState();
}

class _CommunityInsightsPageState extends State<CommunityInsightsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Firestore collection reference
  final CollectionReference reportsCollection =
      FirebaseFirestore.instance.collection('weather_reports');

  // Submit a report to Firestore
  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      try {
        await reportsCollection.add({
          'location': _locationController.text,
          'timestamp': Timestamp.now(),
          'message': _messageController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully!')),
        );

        // Clear the form
        _locationController.clear();
        _messageController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit report: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Insights'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Submit Report Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Your Location',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Your Observation',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your observation';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitReport,
                    child: const Text('Submit Report'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Community Reports',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Real-Time Community Feed
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: reportsCollection
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final reports = snapshot.data!.docs;

                  if (reports.isEmpty) {
                    return const Center(child: Text('No reports yet.'));
                  }

                  return ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      final location = report['location'];
                      final timestamp = (report['timestamp'] as Timestamp)
                          .toDate()
                          .toString();
                      final message = report['message'];

                      return Card(
                        child: ListTile(
                          title: Text(location),
                          subtitle: Text('$message\nReported on: $timestamp'),
                          isThreeLine: true,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
