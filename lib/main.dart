import 'package:flutter/material.dart';

void main() {
  runApp(ComplaintPortalApp());
}

class ComplaintPortalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complaint Portal',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/login_image.png', height: 150),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Secret Id'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComplaintListPage()),
                );
              },
              child: Text('Log in'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('New to Music Lister? Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/login_image.png', height: 150),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Already A Music Lister User? Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class ComplaintListPage extends StatefulWidget {
  @override
  _ComplaintListPageState createState() => _ComplaintListPageState();
}

class _ComplaintListPageState extends State<ComplaintListPage> {
  List<Map<String, String>> complaints = [
    {'title': 'Complaint Title 1', 'summary': 'Here You have to add Summary ..........', 'severity': 'Low', 'status': 'Unresolved'},
    {'title': 'Complaint Title 2', 'summary': 'Here You have to add Summary ..........', 'severity': 'High', 'status': 'Unresolved'},
    {'title': 'Complaint Title 3', 'summary': 'Here You have to add Summary ..........', 'severity': 'Medium', 'status': 'Unresolved'},
  ];

  void addComplaint(String title, String summary, String severity) {
    setState(() {
      complaints.add({
        'title': title,
        'summary': summary,
        'severity': severity,
        'status': 'Unresolved'
      });
    });
  }

  void updateComplaintStatus(int index, String status) {
    setState(() {
      complaints[index]['status'] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Portal'),
      ),
      body: ListView.builder(
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          return ComplaintTile(
            title: complaints[index]['title']!,
            summary: complaints[index]['summary']!,
            severity: complaints[index]['severity']!,
            status: complaints[index]['status']!,
            onResolve: () {
              updateComplaintStatus(index, 'Resolved✓');
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubmitComplaintPage()),
          );
          if (result != null) {
            addComplaint(result['title'], result['summary'], result['severity']);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ComplaintTile extends StatelessWidget {
  final String title;
  final String summary;
  final String severity;
  final String status;
  final VoidCallback onResolve;

  ComplaintTile({required this.title, required this.summary, required this.severity, required this.status, required this.onResolve});

  @override
  Widget build(BuildContext context) {
    Color severityColor;
    switch (severity) {
      case 'Low':
        severityColor = Colors.yellow;
        break;
      case 'Medium':
        severityColor = Colors.orange;
        break;
      case 'High':
        severityColor = Colors.red;
        break;
      default:
        severityColor = Colors.black;
    }

    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(summary),
            SizedBox(height: 5),
            Text(
              severity,
              style: TextStyle(color: severityColor),
            ),
            SizedBox(height: 5),
            Text(status),
          ],
        ),
        trailing: status == 'Unresolved'
            ? ElevatedButton(
                onPressed: onResolve,
                child: Text('Resolve'),
              )
            : Text(status),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewComplaintPage(
                title: title,
                summary: summary,
                severity: severity,
                status: status,
                onResolve: onResolve,
              ),
            ),
          );
        },
      ),
    );
  }
}

class SubmitComplaintPage extends StatefulWidget {
  @override
  _SubmitComplaintPageState createState() => _SubmitComplaintPageState();
}

class _SubmitComplaintPageState extends State<SubmitComplaintPage> {
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  String _severity = 'Low';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Complaint'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Complaint Title'),
            ),
            TextField(
              controller: _summaryController,
              decoration: InputDecoration(labelText: 'Complaint Summary'),
            ),
            DropdownButton<String>(
              value: _severity,
              onChanged: (String? newValue) {
                setState(() {
                  _severity = newValue!;
                });
              },
              items: <String>['Low', 'Medium', 'High']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'title': _titleController.text,
                  'summary': _summaryController.text,
                  'severity': _severity,
                });
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewComplaintPage extends StatelessWidget {
  final String title;
  final String summary;
  final String severity;
  final String status;
  final VoidCallback onResolve;

  ViewComplaintPage({required this.title, required this.summary, required this.severity, required this.status, required this.onResolve});

  @override
  Widget build(BuildContext context) {
    Color severityColor;
    switch (severity) {
      case 'Low':
        severityColor = Colors.yellow;
        break;
      case 'Medium':
        severityColor = Colors.orange;
        break;
      case 'High':
        severityColor = Colors.red;
        break;
      default:
        severityColor = Colors.black;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('View Complaint'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: $title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Summary: $summary'),
            SizedBox(height: 10),
            Text('Severity: $severity', style: TextStyle(color: severityColor)),
            SizedBox(height: 10),
            Text('Status: $status'),
            SizedBox(height: 20),
            if (status == 'Unresolved')
              ElevatedButton(
                onPressed: onResolve,
                child: Text('Resolve'),
              ),
            if (status == 'Resolved✓')
              Text(
                'Resolved✓',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}