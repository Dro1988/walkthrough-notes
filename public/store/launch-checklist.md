# Walkthrough Notes — Play Store launch checklist

## Milo has ready for you
- [x] Signed AAB (v1.9, versionCode 10): `WalkthroughNotes.aab`
- [x] App icon 512×512
- [x] Feature graphic 1024×500
- [x] Privacy policy live: https://walkthrough-notes.onrender.com/privacy/
- [x] Listing copy (short + full description): see play-listing.md
- [x] Data safety answers: see play-listing.md

## You do in Play Console (https://play.google.com/console)
1. Create app → name "Walkthrough Notes", package `com.walkthroughnotes.app`
2. Upload the AAB to the Internal testing track first
3. Store listing: paste the short + full description, upload icon, feature graphic, 2+ phone screenshots
4. Privacy policy: paste the URL above
5. Data safety form: use the answers in play-listing.md (location: not collected; personal info: notes/photos/email only as described)
6. Content rating questionnaire: no objectionable content, no ads → Everyone
7. App access: the app's AI summarize needs the user's own Groq key — note "No special access needed; optional features use user-provided keys"
8. Sensitive permissions: Microphone (dictation incl. background) + Camera (visit photos) — declare as core features

## Still needed from you
- Support email for the privacy policy + store listing (tell me and I'll update both)
- 2+ phone screenshots (I can capture these once v1.9 is verified, or you snap them on your phone)
- $25 Play developer registration (one-time, if not already done for BookShelf)
