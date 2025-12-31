# Supabase Authentication Setup Guide

This guide will walk you through setting up Supabase authentication for the Live Crime Reporter app.

## 📋 Prerequisites

1. A Supabase account (sign up at [supabase.com](https://supabase.com))
2. Your Flutter app project
3. Basic understanding of SQL and database concepts

---

## 🚀 Step 1: Create a Supabase Project

1. Go to [app.supabase.com](https://app.supabase.com)
2. Click **"New Project"**
3. Fill in the project details:
   - **Name**: `live-crime-reporter` (or your preferred name)
   - **Database Password**: Create a strong password (save this securely!)
   - **Region**: Choose the region closest to your users
4. Click **"Create new project"**
5. Wait for the project to be created (takes 1-2 minutes)

---

## 🔑 Step 2: Get Your API Keys

1. In your Supabase project dashboard, go to **Settings** → **API**
2. You'll find:
   - **Project URL**: `https://your-project-id.supabase.co`
   - **anon/public key**: A long JWT token (starts with `eyJ...`)
3. Copy both values - you'll need them for your Flutter app

### Update Your Flutter App Configuration

Open `lib/supabase/supa_config.dart` and update:

```dart
await Supabase.initialize(
  url: 'YOUR_PROJECT_URL',  // Replace with your Project URL
  anonKey: 'YOUR_ANON_KEY',  // Replace with your anon/public key
);
```

---

## 🗄️ Step 3: Create the Users Table

1. In Supabase dashboard, go to **Table Editor**
2. Click **"New Table"**
3. Name it: `users`
4. Add the following columns:

| Column Name | Type | Default Value | Nullable | Description |
|------------|------|---------------|----------|-------------|
| `id` | `int8` | - | ❌ | Primary Key, Auto-increment |
| `uuid` | `uuid` | - | ❌ | Unique identifier from auth |
| `first_name` | `text` | - | ❌ | User's first name |
| `last_name` | `text` | - | ❌ | User's last name |
| `email` | `text` | - | ❌ | User's email (unique) |
| `phone_number` | `text` | - | ✅ | User's phone number |
| `address` | `text` | - | ✅ | User's address |
| `pincode` | `int4` | - | ✅ | User's pincode |
| `state` | `text` | - | ✅ | User's state |
| `city` | `text` | - | ✅ | User's city |
| `language` | `text` | - | ✅ | User's preferred language |
| `points` | `int4` | `0` | ❌ | Gamification points |
| `level` | `int4` | `1` | ❌ | User level |
| `created_at` | `timestamptz` | `now()` | ❌ | Account creation timestamp |
| `updated_at` | `timestamptz` | `now()` | ❌ | Last update timestamp |

5. Set `id` as **Primary Key** (click the key icon)
6. Add a **Unique Constraint** on `email` column
7. Click **"Save"**

### SQL Alternative (Recommended)

Instead of using the UI, you can run this SQL in **SQL Editor**:

```sql
-- Create users table
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  uuid UUID NOT NULL UNIQUE,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  phone_number TEXT,
  address TEXT,
  pincode INTEGER,
  state TEXT,
  city TEXT,
  language TEXT,
  points INTEGER NOT NULL DEFAULT 0,
  level INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create index on uuid for faster lookups
CREATE INDEX idx_users_uuid ON users(uuid);

-- Create index on email for faster lookups
CREATE INDEX idx_users_email ON users(email);
```

---

## 🗄️ Step 4: Create the Crime Report Table

1. Go to **Table Editor** → **New Table**
2. Name it: `crime_report`
3. Add the following columns:

| Column Name | Type | Default Value | Nullable | Description |
|------------|------|---------------|----------|-------------|
| `id` | `int8` | - | ❌ | Primary Key, Auto-increment |
| `user_id` | `int8` | - | ❌ | Foreign Key to users.id |
| `date` | `date` | - | ❌ | Date of incident |
| `time` | `time` | - | ❌ | Time of incident |
| `perpetrator` | `text` | - | ✅ | Perpetrator information |
| `details` | `text` | - | ❌ | Incident details |
| `report_type` | `text` | `'Incident Report'` | ❌ | Type of report |
| `incident_type` | `text` | - | ❌ | Type of incident |
| `status` | `text` | `'New'` | ❌ | Report status |
| `severity` | `text` | - | ❌ | Severity level (Low/Medium/High) |
| `latitude` | `float8` | - | ✅ | Latitude coordinate |
| `longitude` | `float8` | - | ✅ | Longitude coordinate |
| `created_at` | `timestamptz` | `now()` | ❌ | Report creation timestamp |
| `updated_at` | `timestamptz` | `now()` | ❌ | Last update timestamp |

4. Set `id` as **Primary Key**
5. Add **Foreign Key** from `user_id` → `users.id`
6. Click **"Save"**

### SQL Alternative

```sql
-- Create crime_report table
CREATE TABLE crime_report (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  time TIME NOT NULL,
  perpetrator TEXT,
  details TEXT NOT NULL,
  report_type TEXT NOT NULL DEFAULT 'Incident Report',
  incident_type TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'New',
  severity TEXT NOT NULL,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create index on user_id for faster lookups
CREATE INDEX idx_crime_report_user_id ON crime_report(user_id);

-- Create index on created_at for sorting
CREATE INDEX idx_crime_report_created_at ON crime_report(created_at DESC);
```

---

## 🔐 Step 5: Configure Authentication Settings

1. Go to **Authentication** → **Settings**
2. Configure the following:

### Email Auth Settings

- ✅ **Enable Email Signup**: ON
- ✅ **Confirm Email**: ON (Recommended for production)
- ✅ **Secure Email Change**: ON
- ✅ **Double Confirm Email Changes**: ON (Recommended)

### Email Templates

1. Go to **Authentication** → **Email Templates**
2. Customize the following templates:
   - **Confirm signup**: Welcome email with verification link
   - **Magic Link**: Login link email
   - **Change Email Address**: Email change confirmation
   - **Reset Password**: Password reset email

### Site URL Configuration

1. Go to **Authentication** → **URL Configuration**
2. Set **Site URL**: 
   - Development: `http://localhost:3000`
   - Production: Your app's URL
3. Add **Redirect URLs**:
   - `io.supabase.flutterquickstart://login-callback/`
   - `io.supabase.flutterquickstart://reset-password`
   - `com.yourapp.livecrimereporter://login-callback/` (if using custom scheme)

---

## 🛡️ Step 6: Set Up Row Level Security (RLS)

### Enable RLS on Users Table

1. Go to **Table Editor** → `users` table
2. Click **"Enable RLS"** toggle
3. Go to **Policies** tab
4. Create the following policies:

#### Policy 1: Users can read their own data
```sql
CREATE POLICY "Users can read own data"
ON users
FOR SELECT
USING (auth.uid() = uuid);
```

#### Policy 2: Users can update their own data
```sql
CREATE POLICY "Users can update own data"
ON users
FOR UPDATE
USING (auth.uid() = uuid);
```

#### Policy 3: Service role can insert (for signup)
```sql
CREATE POLICY "Service role can insert users"
ON users
FOR INSERT
WITH CHECK (true);
```

### Enable RLS on Crime Report Table

1. Go to **Table Editor** → `crime_report` table
2. Click **"Enable RLS"** toggle
3. Create the following policies:

#### Policy 1: Users can read all reports
```sql
CREATE POLICY "Users can read all reports"
ON crime_report
FOR SELECT
USING (true);
```

#### Policy 2: Users can insert their own reports
```sql
CREATE POLICY "Users can insert own reports"
ON crime_report
FOR INSERT
WITH CHECK (
  auth.uid() IN (
    SELECT uuid FROM users WHERE id = user_id
  )
);
```

#### Policy 3: Users can update their own reports
```sql
CREATE POLICY "Users can update own reports"
ON crime_report
FOR UPDATE
USING (
  auth.uid() IN (
    SELECT uuid FROM users WHERE id = user_id
  )
);
```

---

## 🔄 Step 7: Create Database Functions (Optional but Recommended)

### Function to Auto-Update updated_at Timestamp

Go to **SQL Editor** and run:

```sql
-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger for users table
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for crime_report table
CREATE TRIGGER update_crime_report_updated_at
    BEFORE UPDATE ON crime_report
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
```

---

## 📧 Step 8: Configure Email Provider (SMTP)

For production, configure a custom SMTP provider:

1. Go to **Settings** → **Auth** → **SMTP Settings**
2. Choose a provider (SendGrid, Mailgun, AWS SES, etc.)
3. Enter your SMTP credentials
4. Test the email delivery

**Note**: Supabase provides a default email service, but it has rate limits. For production, use a dedicated SMTP provider.

---

## 🧪 Step 9: Test Your Setup

### Test Signup Flow

1. Run your Flutter app
2. Navigate to the signup screen
3. Fill in the form and submit
4. Check your email for verification link
5. Click the verification link
6. Try logging in

### Test Login Flow

1. Use the credentials you just created
2. Verify you can log in successfully
3. Check that user data is stored in the `users` table

### Test Password Reset

1. Click "Forgot Password"
2. Enter your email
3. Check your email for reset link
4. Follow the reset process

---

## 🔍 Step 10: Verify Database Structure

Run this query in **SQL Editor** to verify everything is set up correctly:

```sql
-- Check users table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'users'
ORDER BY ordinal_position;

-- Check crime_report table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'crime_report'
ORDER BY ordinal_position;

-- Check RLS policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename IN ('users', 'crime_report');
```

---

## 🚨 Common Issues and Solutions

### Issue 1: "Email not confirmed" error

**Solution**: 
- Check **Authentication** → **Settings** → **Email Auth** → **Confirm Email** is enabled
- Verify the email was sent (check spam folder)
- Use the resend email functionality in the app

### Issue 2: "User not found in users table" after signup

**Solution**:
- Check that the `createUser` function in `UserService` is being called
- Verify RLS policies allow inserts
- Check Supabase logs for errors

### Issue 3: "Foreign key constraint violation"

**Solution**:
- Ensure `user_id` in `crime_report` references a valid `users.id`
- Check that the user exists before creating a report

### Issue 4: "Permission denied" when reading/writing data

**Solution**:
- Verify RLS is enabled and policies are correctly configured
- Check that the user is authenticated (`auth.uid()` is not null)
- Review policy conditions

---

## 📱 Step 11: Configure Deep Links (For Mobile Apps)

### Android Configuration

1. Open `android/app/src/main/AndroidManifest.xml`
2. Add intent filter to your main activity:

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="io.supabase.flutterquickstart" />
</intent-filter>
```

### iOS Configuration

1. Open `ios/Runner/Info.plist`
2. Add URL scheme:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>io.supabase.flutterquickstart</string>
        </array>
    </dict>
</array>
```

---

## ✅ Checklist

Before going to production, ensure:

- [ ] All tables are created with correct schema
- [ ] RLS policies are enabled and tested
- [ ] Email verification is working
- [ ] Password reset is working
- [ ] Deep links are configured
- [ ] SMTP is configured (for production)
- [ ] API keys are stored securely (not hardcoded)
- [ ] Error handling is implemented
- [ ] User data is being saved correctly
- [ ] Crime reports are being saved correctly

---

## 🔒 Security Best Practices

1. **Never commit API keys to version control**
   - Use environment variables or secure storage
   - Consider using `flutter_dotenv` package

2. **Enable RLS on all tables**
   - Never disable RLS in production
   - Test policies thoroughly

3. **Use strong passwords**
   - Enforce password requirements in your app
   - Consider password strength validation

4. **Enable email verification**
   - Prevents fake accounts
   - Improves security

5. **Monitor your Supabase dashboard**
   - Check logs regularly
   - Set up alerts for unusual activity

---

## 📚 Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Flutter Guide](https://supabase.com/docs/guides/flutter)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [Supabase Auth Helpers](https://supabase.com/docs/reference/dart/auth-helpers)

---

## 🆘 Support

If you encounter issues:

1. Check Supabase dashboard logs
2. Review Flutter console output
3. Verify your configuration matches this guide
4. Check Supabase status page
5. Review Supabase community forums

---

**Last Updated**: 2024
**App Version**: 1.0.0

