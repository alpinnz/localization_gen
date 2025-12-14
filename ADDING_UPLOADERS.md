# Adding Uploaders to pub.dev Package

This guide explains how to add additional uploaders (maintainers) to your package on pub.dev.

## Prerequisites

- Package must be published to pub.dev first
- You must be an existing uploader/owner of the package
- You need the email address of the person you want to add

## Method 1: Using pub.dev Website (Recommended)

This is the easiest and most user-friendly method.

### Steps:

1. **Publish your package** (if not already published):
   ```bash
   dart pub publish
   ```

2. **Login to pub.dev**:
   - Go to https://pub.dev
   - Sign in with your Google account

3. **Navigate to your package**:
   - Go to https://pub.dev/packages/localization_gen
   - Or click on your package from "My packages" in your profile

4. **Access Admin Panel**:
   - Click on the **"Admin"** tab at the top of the package page
   - You'll see the "Uploaders" section

5. **Invite Uploader**:
   - Click **"Invite uploader"** button
   - Enter the email address of the person you want to add
   - Click **"Send invitation"**

6. **Invitee accepts invitation**:
   - The invited person will receive an email
   - They must click the link in the email to accept
   - After accepting, they become an uploader

## Method 2: Using Command Line

You can manage uploaders using the `dart pub uploader` command.

### Add an Uploader:

```bash
dart pub uploader add <email@example.com>
```

Example:
```bash
dart pub uploader add developer@example.com
```

### Remove an Uploader:

```bash
dart pub uploader remove <email@example.com>
```

### List Current Uploaders:

```bash
dart pub uploader list
```

### Important Notes:

- You must run these commands from the package directory
- The package must already be published to pub.dev
- You must be authenticated (will prompt for login if needed)
- The email must be associated with a Google account

## Method 3: During First Publication

When you first publish a package, you automatically become the initial uploader.

```bash
# First time publication
dart pub publish

# You'll be prompted to authenticate with Google
# After successful publication, you're the first uploader
```

## Understanding Unverified Uploaders

### What is an "Unverified" Uploader?

An **unverified uploader** is someone who:
- Has been invited to upload to a package
- Has accepted the invitation
- But pub.dev hasn't fully verified their identity yet
- They can still upload new versions of the package

### Verification Process:

1. **Invitation sent** → Status: Pending
2. **Invitation accepted** → Status: Unverified uploader
3. **Identity verified by pub.dev** → Status: Verified uploader

Unverified uploaders can still:
- Upload new package versions
- Manage package metadata
- Invite other uploaders

## Best Practices

### 1. Use Email Associated with Google Account

The email you use to invite must be associated with a Google account:
- Gmail addresses work automatically
- Other email providers must be linked to Google account first

### 2. Verify Email Before Inviting

Ask the person to:
- Ensure they have a Google account
- Verify which email is associated with their Google account
- Use that specific email when you send the invitation

### 3. Multiple Uploaders for Team Projects

For team projects, add multiple uploaders:
- Add all core team members
- Ensures continuity if one person is unavailable
- Allows collaborative package maintenance

### 4. Security Considerations

- Only add trusted team members
- Uploaders have full control over the package
- They can publish new versions
- They can add/remove other uploaders
- Choose uploaders carefully

## Troubleshooting

### "Email not found" Error

**Problem:** The email you entered isn't associated with a Google account.

**Solution:** 
- Ask the person to sign up for a Google account with that email
- Or use their existing Google account email

### Invitation Not Received

**Problem:** The invited person didn't receive the email.

**Solutions:**
- Check spam/junk folder
- Verify the email address is correct
- Re-send the invitation
- Try using a different email address

### Cannot Add Uploader via Command Line

**Problem:** `dart pub uploader add` command fails.

**Solutions:**
- Ensure package is already published
- Run from the package root directory
- Check you're authenticated (`dart pub login`)
- Verify you're an existing uploader

### Uploader Can't Publish

**Problem:** New uploader gets errors when trying to publish.

**Solutions:**
- Ensure they've accepted the invitation
- They must authenticate: `dart pub login`
- Check they're using the correct Google account
- Verify package version is incremented

## Example Workflow

Here's a complete example of adding a team member:

```bash
# 1. You (package owner) publish the package
cd /path/to/your/package
dart pub publish

# 2. Add your team member as uploader
dart pub uploader add teammate@example.com

# Output:
# Uploading teammate@example.com to package localization_gen...
# Invitation sent to teammate@example.com

# 3. Team member accepts invitation via email link

# 4. Team member can now publish updates
# (on their machine)
cd /path/to/package
# Make changes, update version in pubspec.yaml
dart pub publish

# 5. Verify uploaders list
dart pub uploader list

# Output:
# uploaders for package localization_gen:
#   you@example.com (verified)
#   teammate@example.com (verified)
```

## Managing Uploaders

### List All Uploaders:

```bash
dart pub uploader list
```

### Remove Yourself (Transfer Ownership):

```bash
# First add another uploader
dart pub uploader add newowner@example.com

# Then remove yourself
dart pub uploader remove your@email.com
```

**Warning:** Make sure there's at least one other uploader before removing yourself!

### Add Multiple Uploaders:

```bash
dart pub uploader add developer1@example.com
dart pub uploader add developer2@example.com
dart pub uploader add developer3@example.com
```

## For This Package (localization_gen)

To add uploaders to **localization_gen**:

### Via Website:
1. Go to https://pub.dev/packages/localization_gen/admin
2. Scroll to "Uploaders" section
3. Click "Invite uploader"
4. Enter email and send

### Via Command Line:
```bash
cd /Users/alpinnz/Projects/Alpinnz/localization_gen
dart pub uploader add <email@example.com>
```

## Additional Resources

- [Pub.dev Publishing Guide](https://dart.dev/tools/pub/publishing)
- [Package Uploader Documentation](https://dart.dev/tools/pub/cmd/pub-uploader)
- [Pub.dev Help Center](https://pub.dev/help)

## Summary

**Recommended Method:** Use pub.dev website interface
**Alternative:** Use `dart pub uploader` command
**Requirement:** Package must be published first
**Email:** Must be associated with Google account

Adding uploaders allows team collaboration and ensures your package can be maintained by multiple trusted developers.

