# MaterialApp সম্পূর্ণ গাইড - বিস্তারিত ব্যাখ্যা ও উদাহরণ

## MaterialApp কি? (What is MaterialApp?)

**MaterialApp** হলো Flutter-এর একটি root-level widget যা Material Design theme এবং structure প্রদান করে। এটি整个অ্যাপের configuration এবং settings manage করে।

```dart
MaterialApp(
  title: 'My App',
  theme: ThemeData.light(),
  home: HomeScreen(),
  // ... অন্যান্য important properties
)
```

---

## MaterialApp-এর প্রধান প্রোপার্টিস (Main Properties)

### ১. Basic Properties (মৌলিক প্রোপার্টিস)
```dart
MaterialApp(
  // অ্যাপের নাম (Play Store/App Store-তে দেখাবে)
  title: 'My Flutter App',
  
  // অ্যাপের ইউনিক আইডি
  key: Key('main_app'),
  
  // Color যে কালারটি system UI-তে use হবে (status bar, navigation bar)
  color: Colors.blue,
  
  // অ্যাপের theme (রং, ফন্ট, style)
  theme: ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: 'Roboto',
  ),
  
  // Dark mode theme
  darkTheme: ThemeData.dark(),
  
  // Theme mode (light, dark, system)
  themeMode: ThemeMode.system,
  
  // প্রথম স্ক্রিন (Home page)
  home: HomeScreen(),
)
```

### ২. Navigation Properties (নেভিগেশন প্রোপার্টিস)
```dart
MaterialApp(
  // Named routes (পাতা নেভিগেশনের জন্য)
  routes: {
    '/home': (context) => HomeScreen(),
    '/profile': (context) => ProfileScreen(),
    '/settings': (context) => SettingsScreen(),
  },
  
  // Initial route (শুরু করার route)
  initialRoute: '/home',
  
  // Unknown route handling (ভুল route এলে কি দেখাবে)
  onGenerateRoute: (settings) {
    return MaterialPageRoute(
      builder: (context) => NotFoundScreen(),
    );
  },
  
  // Route observer (নেভিগেশন track করার জন্য)
  navigatorObservers: [RouteObserver()],
)
```

### ৩. Localization & Accessibility (লোকালাইজেশন এবং অ্যাক্সেসিবিলিটি)
```dart
MaterialApp(
  // App-এর supported locales
  supportedLocales: [
    Locale('en', 'US'), // English
    Locale('bn', 'BD'), // Bengali
    Locale('es', 'ES'), // Spanish
  ],
  
  // Default locale
  locale: Locale('bn', 'BD'),
  
  // Localization delegates
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  
  // Accessibility support
  showSemanticsDebugger: false,
)
```

### ৪. Debug & Performance (ডিবাগ এবং পারফরম্যান্স)
```dart
MaterialApp(
  // Debug banner hide/show
  debugShowCheckedModeBanner: false,
  
  // Performance overlay
  showPerformanceOverlay: false,
  
  // Grid overlay for debugging layout
  debugShowMaterialGrid: false,
)
```

---

## সম্পূর্ণ MaterialApp উদাহরণ

### উদাহরণ ১: বেসিক MaterialApp
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tutorial App',
      theme: ThemeData(
        // Primary color
        primarySwatch: Colors.blue,
        
        // Color scheme
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange,
        ),
        
        // Typography
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        
        // Button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        
        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.orangeAccent,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Flutter!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### উদাহরণ ২: Multi-Route MaterialApp
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MultiRouteApp());
}

class MultiRouteApp extends StatelessWidget {
  const MultiRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Route App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      // Initial route (শুরু করার জায়গা)
      initialRoute: '/',
      
      // Named routes ডিফাইন করা
      routes: {
        '/': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
        '/products': (context) => ProductListScreen(),
        '/products/detail': (context) => ProductDetailScreen(),
      },
      
      // Unknown route handling
      onGenerateRoute: (settings) {
        // Dynamic route handling
        if (settings.name == '/user/:id') {
          final userId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => UserProfileScreen(userId: userId),
          );
        }
        
        // 404 Page Not Found
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Page Not Found')),
            body: Center(child: Text('404 - Page not found!')),
          ),
        );
      },
      
      // Navigation observer
      navigatorObservers: [MyRouteObserver()],
      debugShowCheckedModeBanner: false,
    );
  }
}

// Custom Route Observer
class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    print('Navigated to: ${route.settings.name}');
  }
}

// Different Screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: Text('Go to Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: Text('Go to Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Profile Screen')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Settings Screen')),
    );
  }
}
```

### উদাহরণ ৩: Advanced MaterialApp with Localization
```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const LocalizedApp());
}

class LocalizedApp extends StatelessWidget {
  const LocalizedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localized App',
      
      // Theme Configuration
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.purple,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
        ),
      ),
      
      // Localization Configuration
      supportedLocales: [
        Locale('en', 'US'), // English
        Locale('bn', 'BD'), // Bengali
        Locale('es', 'ES'), // Spanish
        Locale('ar', 'SA'), // Arabic
      ],
      
      locale: Locale('bn', 'BD'), // Default to Bengali
      
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      
      home: const LocalizationDemoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LocalizationDemoScreen extends StatelessWidget {
  const LocalizationDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localization Demo'),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              _showLanguageDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Flutter!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile Information'),
                subtitle: Text('Manage your account settings'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('App Settings'),
                subtitle: Text('Customize your app experience'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.explore),
              label: Text('Explore Features'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('English'),
              onTap: () {
                // Change locale to English
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('বাংলা'),
              onTap: () {
                // Change locale to Bengali
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Español'),
              onTap: () {
                // Change locale to Spanish
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

### উদাহরণ ৪: Professional E-commerce App Structure
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEasy - ECommerce App',
      
      // Comprehensive Theme Configuration
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue.shade800,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange,
          backgroundColor: Colors.grey.shade50,
        ),
        
        // Typography Scale
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        
        // App Bar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        
        // Button Themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        
        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        
        // Card Theme
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(8),
        ),
      ),
      
      // Dark Theme
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.orangeAccent,
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // Routes Configuration
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/categories': (context) => CategoriesScreen(),
        '/products': (context) => ProductsScreen(),
        '/product/detail': (context) => ProductDetailScreen(),
        '/cart': (context) => CartScreen(),
        '/checkout': (context) => CheckoutScreen(),
        '/profile': (context) => ProfileScreen(),
        '/orders': (context) => OrdersScreen(),
        '/wishlist': (context) => WishlistScreen(),
      },
      
      onGenerateRoute: (settings) {
        // Handle dynamic routes like '/product/123'
        if (settings.name!.startsWith('/product/')) {
          final productId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: productId),
          );
        }
        
        // 404 Error Page
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Page Not Found',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('The requested page could not be found.'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    child: Text('Go to Home'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      
      navigatorObservers: [
        AnalyticsObserver(),
        PerformanceObserver(),
      ],
      
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
    );
  }
}

// Example Screens (Simplified)
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: FlutterLogo(size: 100)),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ShopEasy')),
      body: Center(child: Text('Home Screen')),
    );
  }
}

// Observers
class AnalyticsObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // Send analytics data
    print('Screen viewed: ${route.settings.name}');
  }
}

class PerformanceObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // Monitor performance
    print('Performance: ${route.settings.name} loaded');
  }
}
```

---

## MaterialApp Best Practices

### ১. Theme Management
```dart
// Good Practice - Separate Theme File
ThemeData getLightTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    // ... other theme properties
  );
}

ThemeData getDarkTheme() {
  return ThemeData.dark().copyWith(
    // ... custom dark theme properties
  );
}
```

### ২. Route Management
```dart
// Good Practice - Route Constants
class RouteNames {
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

// Usage
Navigator.pushNamed(context, RouteNames.profile);
```

### ৩. Error Handling
```dart
MaterialApp(
  builder: (context, child) {
    ErrorWidget.builder = (errorDetails) {
      return CustomErrorWidget(errorDetails: errorDetails);
    };
    return child!;
  },
)
```

---

## Common Errors and Solutions

### Error ১: "No MaterialLocalizations found"
**Solution:**
```dart
MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: [Locale('en', 'US')],
)
```

### Error ২: "Navigator operation requested with a context that does not include a Navigator"
**Solution:**
```dart
// Use Builder widget
Builder(
  builder: (context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/next');
      },
      child: Text('Navigate'),
    );
  },
)
```

MaterialApp হলো Flutter app-এর foundation। এটি properly configure করলে আপনার app professional look এবং smooth functionality পাবে! 🚀
