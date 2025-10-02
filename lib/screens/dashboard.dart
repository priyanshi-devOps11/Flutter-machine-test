import 'package:url_launcher/url_launcher.dart';

void openWhatsApp(String phone, String text) async {
  final uri = Uri.parse(
    'https://wa.me/$phone?text=${Uri.encodeComponent(text)}',
  );
  if (await canLaunchUrl(uri))
    await launchUrl(uri, mode: LaunchMode.externalApplication);
}
