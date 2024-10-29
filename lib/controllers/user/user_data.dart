import 'package:supabase_flutter/supabase_flutter.dart';

String? userAvatarUrl() {
  final identities = Supabase.instance.client.auth.currentUser!.identities;

  // Check if identities exist
  if (identities != null && identities.isNotEmpty) {
    // Loop through each identity
    for (var identity in identities) {
      // Check if the provider is Google
      if (identity.provider == 'google') {
        // Get the avatar URL from the identityData
        final avatarUrl = identity.identityData!['avatar_url'];
        return avatarUrl;
      }
    }
  } else {
    return null;
  }
  return null;
}

String? userName() {
  final identities = Supabase.instance.client.auth.currentUser!.identities;

  // Check if identities exist
  if (identities != null && identities.isNotEmpty) {
    // Loop through each identity
    for (var identity in identities) {
      // Check if the provider is Google
      if (identity.provider == 'google') {
        final avatarUrl = identity.identityData!['name'];
        return avatarUrl;
      }
    }
  } else {
    return null;
  }
  return null;
}
