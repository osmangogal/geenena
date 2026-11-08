import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const GeneenaApp());
}

class GeneenaApp extends StatelessWidget {
  const GeneenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'جنيهنا - التطبيق الأسطوري السوداني',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E3A8A),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        fontFamily: 'Cairo',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
      ),
      // اتجاه الكتابة من اليمين لليسار لكل التطبيق
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const LoginScreen(),
    );
  }
}

// ================= 1. شاشة تسجيل الدخول والتحقق =================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _otpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_balance_wallet,
                    size: 80, color: Color(0xFF1E3A8A)),
                const SizedBox(height: 16),
                const Text(
                  'تطبيق جنيهنا',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'رفيقك السوداني الأول لإدارة الديون والحسابات',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    icon: const Icon(Icons.g_mobiledata,
                        size: 32, color: Colors.white),
                    label: const Text('تسجيل الدخول بحساب جوجل',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف لاسترجاع الحساب عبر الواتساب',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _otpSent = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'تم إرسال كود التحقق (OTP) عبر الواتساب بنجاح!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(_otpSent
                        ? 'إعادة إرسال الكود'
                        : 'إرسال كود التحقق عبر الواتساب'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= 2. الواجهة الرئيسية والتنقل =================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DebtsScreen(type: 'داير مني'),
    DebtsScreen(type: 'داير منو'),
    QuickSplitScreen(),
    ProfileAndDevScreen(),
  ];

  static const List<String> _titles = [
    'الديون العلي',
    'الديون اللي عندي',
    'حق القعدة (تقسيم سريع)',
    'حسابي والمطور',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      // IndexedStack عشان الشاشات ما تفقد بياناتها لمن تتنقل بين التابات
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF1E3A8A),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_downward), label: 'داير مني'),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_upward), label: 'داير منو'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'تقسيم سريع'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

// ================= 3. شاشة عرض الديون وإضافتها =================
class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key, required this.type});
  final String type;

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  final List<Map<String, dynamic>> _debts = [
    {'name': 'محمد أحمد', 'amount': 5000, 'note': 'شلتو لـ حلاوة وإندومي'},
    {'name': 'عمر حسن', 'amount': 15000, 'note': 'قرض مؤقت للمواصلات'},
  ];

  void _addNewDebtDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('إضافة دين جديد (${widget.type})'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'اسم الشخص')),
              TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'المبلغ (جنيه سوداني)')),
              TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                      labelText: 'الملاحظة (مثلاً: إندومي، حلاوة)')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text.trim());
              if (nameController.text.trim().isNotEmpty && amount != null) {
                setState(() {
                  _debts.add({
                    'name': nameController.text.trim(),
                    'amount': amount,
                    'note': noteController.text.trim(),
                  });
                });
                Navigator.pop(dialogContext);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('الرجاء إدخال اسم ومبلغ صحيح')),
                );
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalAmount =
        _debts.fold<int>(0, (sum, item) => sum + (item['amount'] as int));

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E3A8A).withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('إجمالي ${widget.type}:',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text('$totalAmount جنيه سوداني',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _debts.length,
              itemBuilder: (context, index) {
                final debt = _debts[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(debt['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle:
                        Text('${debt['note']}\nالمبلغ: ${debt['amount']} ج.س'),
                    isThreeLine: true,
                    trailing: widget.type == 'داير مني'
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BankTransferScreen(
                                        personName: debt['name'] as String,
                                        amount: debt['amount'] as int)),
                              );
                            },
                            child: const Text('سداد'),
                          )
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                _debts.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'تم تحويل المبلغ وحذف الحساب بنجاح!')),
                              );
                            },
                            child: const Text('تم التحويل',
                                style: TextStyle(color: Colors.green)),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewDebtDialog,
        backgroundColor: const Color(0xFF1E3A8A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ================= 4. حاسبة التقسيم السريع (حق القعدة) =================
class QuickSplitScreen extends StatefulWidget {
  const QuickSplitScreen({super.key});

  @override
  State<QuickSplitScreen> createState() => _QuickSplitScreenState();
}

class _QuickSplitScreenState extends State<QuickSplitScreen> {
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _personsController = TextEditingController();
  double _perPerson = 0;

  @override
  void dispose() {
    _totalController.dispose();
    _personsController.dispose();
    super.dispose();
  }

  void _calculateSplit() {
    final double total = double.tryParse(_totalController.text) ?? 0;
    final int persons = int.tryParse(_personsController.text) ?? 0;
    if (persons > 0) {
      setState(() => _perPerson = total / persons);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل عدد الأفراد بشكل صحيح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'قسم فاتورة الجلسة (إندومي، قهوة، عشاء) بالتساوي:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _totalController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'إجمالي الفاتورة (ج.س)',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.money),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _personsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'عدد الأفراد (الناس القاعدين)',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.group),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white),
              onPressed: _calculateSplit,
              child: const Text('احسب نصيب الفرد',
                  style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 1.5),
              ),
              child: Text(
                'نصيب الزول الواحد: ${_perPerson.toStringAsFixed(2)} جنيه سوداني',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= 5. شاشة السداد البنكي =================
class BankTransferScreen extends StatelessWidget {
  const BankTransferScreen(
      {super.key, required this.personName, required this.amount});
  final String personName;
  final int amount;

  static const List<Map<String, String>> banks = [
    {'name': 'بنك الخرطوم (بنكك)', 'account': '1234567890', 'color': '0xFF003366'},
    {'name': 'البنك الإسلامي السوداني', 'account': '0987654321', 'color': '0xFF006633'},
    {'name': 'بنك أمدرمان الوطني', 'account': '1122334455', 'color': '0xFF990000'},
    {'name': 'بنك النيل', 'account': '5544332211', 'color': '0xFF008080'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بوابات السداد البنكي'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('سداد مبلغ: $amount جنيه سوداني لـ $personName',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('اختر التطبيق البنكي (سيتم نسخ رقم الحساب تلقائياً):',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: banks.length,
                itemBuilder: (context, index) {
                  final bank = banks[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(int.parse(bank['color']!)),
                        child: const Icon(Icons.account_balance,
                            color: Colors.white),
                      ),
                      title: Text(bank['name']!,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('رقم الحساب: ${bank['account']}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: bank['account']!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'تم نسخ رقم الحساب (${bank['account']}) إلى الحافظة بنجاح!')),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                onPressed: () {
                  final messenger = ScaffoldMessenger.of(context);
                  Navigator.pop(context);
                  messenger.showSnackBar(
                    const SnackBar(
                        content:
                            Text('تم إتمام عملية السداد بنجاح وتصفية الحساب!')),
                  );
                },
                child: const Text('تم التحويل (إتمام العملية)',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= 6. شاشة الملف الشخصي ومعلومات المطور =================
class ProfileAndDevScreen extends StatelessWidget {
  const ProfileAndDevScreen({super.key});

  Future<void> _launchFacebook(BuildContext context) async {
    final Uri url = Uri.parse('https://www.facebook.com/osmanjksa249');
    final messenger = ScaffoldMessenger.of(context);
    final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('تعذر فتح الرابط')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF1E3A8A),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text('عثمان فضل الكريم (عثمان جكسا)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('تطبيق جنيهنا - الإصدار الأسطوري 1.0',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 20),
          const Text(
            'تم تطوير وتصميم هذا التطبيق بواسطة المصمم والمبرمج السوداني:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _launchFacebook(context),
              icon: const Icon(Icons.facebook, color: Colors.white),
              label: const Text('تواصل مع المطور (عثمان فضل)',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1877F2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
