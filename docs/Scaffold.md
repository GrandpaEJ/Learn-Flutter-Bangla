# Scaffold সম্পূর্ণ গাইড - বিস্তারিত ব্যাখ্যা ও উদাহরণ

## Scaffold কি? (What is Scaffold?)

**Scaffold** হলো Flutter-এর একটি fundamental widget যা Material Design app-এর basic layout structure প্রদান করে। এটি একটি page বা screen-এর skeleton হিসেবে কাজ করে।

```dart
Scaffold(
  appBar: AppBar(),      // উপরের বার
  body: Container(),     // মূল কন্টেন্ট
  drawer: Drawer(),      // সাইড মেনু
  // ... অন্যান্য প্রোপার্টি
)
```

---

## Scaffold-এর প্রধান কম্পোনেন্টস (Main Components)

### ১. AppBar (অ্যাপ বার)
```dart
AppBar(
  title: Text('My App'),                    // টাইটেল
  backgroundColor: Colors.blue,             // ব্যাকগ্রাউন্ড কালার
  elevation: 4,                            // শেডো
  leading: IconButton(                      // বাম পাশের আইকন
    icon: Icon(Icons.menu),
    onPressed: () {},
  ),
  actions: [                               // ডান পাশের আইকনগুলো
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {},
    ),
  ],
)
```

### ২. Body (বডি)
```dart
body: Container(
  padding: EdgeInsets.all(16),
  child: Column(
    children: [
      Text('Main Content'),
      ElevatedButton(
        onPressed: () {},
        child: Text('Click Me'),
      ),
    ],
  ),
)
```

### ৩. Floating Action Button (ফ্লোটিং অ্যাকশন বাটন)
```dart
floatingActionButton: FloatingActionButton(
  onPressed: () {
    // Button pressed logic
  },
  child: Icon(Icons.add),
  backgroundColor: Colors.blue,
  tooltip: 'Add Item',  // Hover text
),
```

### ৪. Drawer (ড্রয়ার)
```dart
drawer: Drawer(
  child: ListView(
    children: [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text(
          'Menu',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: Text('Home'),
        onTap: () {
          // Navigate to home
        },
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Settings'),
        onTap: () {
          // Navigate to settings
        },
      ),
    ],
  ),
),
```

### ৫. Bottom Navigation Bar (বটম নেভিগেশন বার)
```dart
bottomNavigationBar: BottomNavigationBar(
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      label: 'School',
    ),
  ],
  currentIndex: _selectedIndex,
  onTap: _onItemTapped,
),
```

---

## Scaffold-এর সম্পূর্ণ প্রোপার্টি লিস্ট

```dart
Scaffold(
  // Basic Properties
  key: Key('scaffold_key'),
  
  // App Bar
  appBar: AppBar(...),
  
  // Body Content
  body: Container(...),
  
  // Floating Action Button
  floatingActionButton: FloatingActionButton(...),
  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  
  // Drawer (Left Side Menu)
  drawer: Drawer(...),
  
  // End Drawer (Right Side Menu)
  endDrawer: Drawer(...),
  
  // Bottom Navigation Bar
  bottomNavigationBar: BottomNavigationBar(...),
  
  // Persistent Footer Buttons
  persistentFooterButtons: [
    ElevatedButton(...),
    OutlinedButton(...),
  ],
  
  // Bottom Sheet
  bottomSheet: Container(...),
  
  // Background Color
  backgroundColor: Colors.white,
  
  // Resize to Avoid Bottom Inset
  resizeToAvoidBottomInset: true,
  
  // Safe Area
  extendBody: false,
  extendBodyBehindAppBar: false,
)
```

---

## বাস্তব উদাহরণ: সম্পূর্ণ স্ক্রিন ডিজাইন

### উদাহরণ ১: সাধারণ প্রোফাইল পেজ
```dart
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              print('Edit Profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
            ),
            SizedBox(height: 16),
            Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'flutter.developer@email.com',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(Icons.phone),
                title: Text('+1 234 567 890'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text('New York, USA'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call or message functionality
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
```

### উদাহরণ ২: টাস্ক ম্যানেজমেন্ট অ্যাপ
```dart
class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  int _selectedIndex = 0;
  final List<String> _tasks = ['Task 1', 'Task 2', 'Task 3'];

  void _addTask() {
    setState(() {
      _tasks.add('Task ${_tasks.length + 1}');
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Task Manager',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_tasks[index]),
            onDismissed: (direction) => _deleteTask(index),
            background: Container(color: Colors.red),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.task),
                title: Text(_tasks[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTask(index),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Completed',
          ),
        ],
      ),
    );
  }
}
```

### উদাহরণ ৩: ই-কমার্স প্রোডাক্ট পেজ
```dart
class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
          IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://example.com/product.jpg',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smartphone XYZ',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$599.99',
                    style: TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Product Description: Lorem ipsum dolor sit amet...',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      Icon(Icons.star, color: Colors.amber),
                      Icon(Icons.star, color: Colors.amber),
                      Icon(Icons.star, color: Colors.amber),
                      Icon(Icons.star_half, color: Colors.amber),
                      SizedBox(width: 8),
                      Text('4.5 (120 reviews)'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.shopping_cart),
                label: Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Buy Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Scaffold ব্যবহারের Best Practices

### ১. Responsive Design
```dart
Scaffold(
  body: LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return _buildWideLayout();
      } else {
        return _buildNormalLayout();
      }
    },
  ),
)
```

### ২. Safe Area Handling
```dart
Scaffold(
  body: SafeArea(
    child: YourContentHere(),
  ),
)
```

### ৩. Error Handling
```dart
Scaffold(
  body: Builder(
    builder: (context) {
      try {
        return YourContent();
      } catch (e) {
        return ErrorWidget(e.toString());
      }
    },
  ),
)
```

---

## সাধারণ Errors এবং Solutions

### Error ১: "Scaffold.of() called with a context that does not contain a Scaffold"
**Solution:**
```dart
// ❌ Wrong
Scaffold.of(context).showSnackBar(...);

// ✅ Correct
Builder(
  builder: (context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hello')),
        );
      },
      child: Text('Show SnackBar'),
    );
  },
)
```

### Error ২: "setState() called after dispose()"
**Solution:**
```dart
void _method() {
  if (mounted) {
    setState(() {
      // Your code
    });
  }
}
```

---

## উপসংহার

Scaffold হলো Flutter app development-এর heart। এটি আপনার app-এর structure নির্ধারণ করে এবং user-friendly interface তৈরি করতে সাহায্য করে। উপরের উদাহরণগুলো follow করে আপনি professional-looking app easily তৈরি করতে পারবেন! 🚀
