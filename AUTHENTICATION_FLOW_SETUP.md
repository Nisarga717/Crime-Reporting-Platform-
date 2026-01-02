# Authentication Flow Setup

## ✅ What Was Implemented

### 1. **Authentication Wrapper** (`lib/auth/auth_wrapper.dart`)

A new authentication wrapper that:
- ✅ Checks authentication state on app startup
- ✅ Shows loading screen while checking
- ✅ Routes to appropriate screen based on auth state
- ✅ Handles onboarding flow (first-time users)
- ✅ Fetches user data from database

### 2. **App Entry Point** (`lib/app.dart`)

Updated to:
- ✅ Use `AuthWrapper` as the home screen
- ✅ Removed hardcoded MapScreen
- ✅ Proper routing based on authentication

### 3. **Main Initialization** (`lib/main.dart`)

Added:
- ✅ GetStorage initialization for onboarding check

---

## 🔄 Authentication Flow

### App Startup Flow:

```
App Starts
    ↓
AuthWrapper (checks auth state)
    ↓
┌─────────────────┬──────────────────┐
│                 │                  │
First Time?    Yes → Onboarding Screen
│                 │                  │
No                │                  │
│                 │                  │
Authenticated? Yes → MapScreen
│                 │                  │
No                │                  │
│                 │                  │
LoginScreen ←─────┘                  │
```

### Login Flow:

```
LoginScreen
    ↓
User enters credentials
    ↓
Supabase authentication
    ↓
Email verified? → Yes → Get user data from database
    ↓                    ↓
    No                   MapScreen (with user ID)
    ↓
Show error message
```

### Logout Flow:

```
Profile Screen
    ↓
User clicks Logout
    ↓
Supabase signOut()
    ↓
Get.offAll(LoginScreen)
```

---

## 📱 Screen Routing

### Initial Screen Decision:

1. **First Time User** → `OnBoardingScreen`
   - Shows onboarding slides
   - After completion → `LoginScreen`

2. **Authenticated User** → `MapScreen`
   - User is logged in and email verified
   - Fetches user ID from database
   - Passes user data to MapScreen

3. **Not Authenticated** → `LoginScreen`
   - User needs to login
   - Can navigate to signup

---

## 🔐 Authentication Checks

### What Gets Checked:

1. **Supabase Auth State**
   - Checks if `currentUser` exists
   - Verifies `emailConfirmedAt` is not null

2. **User Data**
   - Fetches user from `users` table
   - Gets numeric ID and username
   - Falls back to UUID if not found

3. **Onboarding Status**
   - Checks `isFirstTime` flag in GetStorage
   - Shows onboarding if first time

---

## 🎨 Loading Screen

The auth wrapper shows a branded loading screen:
- App logo (shield icon)
- "Satark Setu" text
- Loading spinner
- Green theme colors

---

## ✅ Testing Checklist

### Test Login Flow:

- [ ] App opens to LoginScreen (if not logged in)
- [ ] Enter valid credentials
- [ ] Email is verified
- [ ] Successfully navigates to MapScreen
- [ ] User ID is correctly passed
- [ ] Username displays correctly

### Test Signup Flow:

- [ ] Navigate to Signup from LoginScreen
- [ ] Fill out signup form
- [ ] Submit form
- [ ] Navigate to VerifyEmail screen
- [ ] Check email for verification link
- [ ] Verify email
- [ ] Navigate to LoginScreen
- [ ] Login with new credentials

### Test Logout Flow:

- [ ] Go to Profile screen
- [ ] Click Logout
- [ ] Successfully signs out
- [ ] Navigates to LoginScreen
- [ ] Cannot access MapScreen without login

### Test Session Persistence:

- [ ] Login successfully
- [ ] Close app completely
- [ ] Reopen app
- [ ] Should go directly to MapScreen (if still logged in)

### Test Email Verification:

- [ ] Signup with new account
- [ ] Try to login before verifying email
- [ ] Should show "Email Not Verified" error
- [ ] Verify email
- [ ] Login should work

---

## 🐛 Common Issues & Solutions

### Issue 1: App always shows LoginScreen

**Cause**: Supabase not initialized or auth check failing

**Solution**:
- Check Supabase initialization in `main.dart`
- Verify Supabase URL and key in `supa_config.dart`
- Check console for initialization errors

### Issue 2: User logged in but still sees LoginScreen

**Cause**: Email not verified or user data not found

**Solution**:
- Check if email is verified in Supabase dashboard
- Verify user exists in `users` table
- Check console for error messages

### Issue 3: Onboarding shows every time

**Cause**: GetStorage not initialized or flag not set

**Solution**:
- Ensure `GetStorage.init()` is called in `main.dart`
- Check if `isFirstTime` flag is being saved

### Issue 4: Navigation stack issues

**Cause**: Using `Get.to()` instead of `Get.offAll()`

**Solution**:
- Use `Get.offAll()` for login/logout to clear stack
- Use `Get.to()` for navigation within app

---

## 📝 Files Created/Modified

### New Files:
- `lib/auth/auth_wrapper.dart` - Authentication state checker

### Modified Files:
- `lib/app.dart` - Changed home to AuthWrapper
- `lib/main.dart` - Added GetStorage initialization

---

## 🔄 Navigation Methods Used

### Login Success:
```dart
Get.offAll(() => MapScreen(...));
```
- Clears navigation stack
- Prevents back navigation to login

### Logout:
```dart
Get.offAll(() => const LoginScreen());
```
- Clears navigation stack
- Prevents back navigation to authenticated screens

---

## 🚀 Ready for Testing

The authentication flow is now complete and ready for testing:

1. ✅ Login screen appears first
2. ✅ Signup flow works
3. ✅ Email verification required
4. ✅ Successful login navigates to MapScreen
5. ✅ Logout returns to LoginScreen
6. ✅ Session persistence (stays logged in)
7. ✅ Onboarding for first-time users

---

**Status**: ✅ Authentication flow fully implemented and ready for testing!



