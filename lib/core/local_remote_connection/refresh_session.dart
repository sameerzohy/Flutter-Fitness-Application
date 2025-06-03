import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> refreshSession(SupabaseClient client) async {
  await client.auth.refreshSession();
}
