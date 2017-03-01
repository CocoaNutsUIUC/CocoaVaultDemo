# CocoaVault
#### Keychain, TouchID, and how to create a sweet landing page!

---

### Welcome to CocoaNuts

- This is a tutorial made by Steven Shang for CocoaNuts.
- CocoaNuts is a community of iOS developers. We meet weekly on Thursday in *Siebel Center 2124* from *6:30* to *8:30 PM*.
- It's okay to feel overwhelmed by the tutorial. We're here to help.
- Ask lots of questions!

---

### CocoaVault Overview

You will learn how to store & retrieve user passwords using ***Keychain Services***, how to integrate ***TouchID*** authentication, and how to make a simple but beautiful login page.

![](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/GIFs/demo.gif)

---

### Xcode Overview:
*(Skip if you're familiar with Xcode)*

- Xcode is an integrated development environment (IDE) which contains all the tools you need to build an iOS, watchOS, macOS, or tvOS app.
- On the left side, you have the ***Navigator***; in the middle, you have the ***Editor***; on the right side, you have various ***Utilities***; on the top, you have the ***toolbar***.
- Xcode uses ***storyboards*** to lay out the app's user interface. It automatically generates a XML document, so you won't have to.
- Because we love iOS devices of all shapes and sizes, Xcode's ***storyboards*** use what's called ***Auto Layout*** to dynamically calculate the size and position of all the views in your app. You just have to create constraints on those  views.
- Press `Command + B` to build your project. Press `Command + R` to run your project in a simulator. Press `Command + Shift + K` to clean your built codes. These shortcuts will come in handy in the future!

---


### Project Set Up

- Open Xcode 8.0+, click on ***"Create a new Xcode project"*** and select ***"Single View Application"***, then click next.
- Fill in the name ***"CocoaVault"*** (or some other name if you're feeling rebellious) and click next.

    ![](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/GIFs/create_project.gif)

---

### Storyboard Set Up

Steve is very much a minimalist when it comes to design. So we'll set up our app to be as simple and easy-to-use as humanly possible, which is often a good design practice!

Go to *Main.storyboard* in your Navigator, follow the video to set up your storyboard:

***https://www.youtube.com/watch?v=ypAaZUbrBeg***

In the video, you will:

1. Drag one ***Label***, two ***Text Field***, and three ***Button*** onto your fake iPhone screen in the middle. It doesn't matter where *exactly* you put them right now. Once we add some constraints, they'll fall in place pretty neatly.

2. Rename our label to "CocoaVault" and set the font to **bold**, and rename the left button to "***Log In***", the right button to "***Touch***", and the bottom button to "***Create New Vault***".

3. Add constraints to out views! Now, this step can be kinda confusing, so if you've any question, please ask!

4. Next, to make these buttons, textfields, and label manifest in our code, create ***outlets*** using the Assistance Editor (*the intersecting circles icon upper left corner*), select `ViewController.swift` and `Control + drag` your views to inside the class.

    - *Note: use `Control` + drag from one view to another view to create constraints between them!*
    
    - *Note: we created 6 `IBOutlets` and 3 `IBActions`, not 9 `IBOutlets`. The `IBActions` are event-triggered functions for user interaction.*
    
    - *Note: you should have the following constraints on each of our views:*
    
    <img src="https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/1.png" width="400">
    <img src="https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/2.png" width="400">
    <img src="https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/3.png" width="400">
    <img src="https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/4.png" width="400">
    <img src="https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/5.png" width="400">
    <img src="https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/6.png" width="400">

    Remember, if you're confused, ask us questions!

---

### Coding!

*Note: You should not simply copy the codes from the tutorial! Instead, try to understand every line of code as you type them. If you run into something you don't understand, either ask questions or stackoverflow it! Learning is an active process!*

---

### Part I: Keychain:

In order to use Keychain to store and retrieve username and password, we need to write a ***Keychain Wrapper*** that helps us to abstract away the nitty gritty stuff of interacting with they keychain API. There're many open sourced Keychain wrappers that are available online. But in order to help you understand how Keychain works, we will write a ***bare-bone version*** of a wrapper.

- First, create a new Swift file in your project, name it `KeychainHelper.swift`.

- Create a `open class` named `KeychainHelper` in your file:

        open class KeyChainHelper {
            // our wrapper
        }

    The `open` keyword here is very close to `static`, making the class and its members accessible by any source file. Different from `static`, it allows you to subclass the open class.

- Copy and paste the following ***boilerplate code*** into your file, right on top of your class:

        import Security

        let serviceValue = "KeyForPassword"
        let kSecClassValue = NSString(format: kSecClass)
        let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
        let kSecValueDataValue = NSString(format: kSecValueData)
        let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
        let kSecAttrServiceValue = NSString(format: kSecAttrService)
        let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
        let kSecReturnDataValue = NSString(format: kSecReturnData)
        let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

    These codes are some standard definitions to be used to create `keychain query` objects. It's fine to just copy and paste this time.

- Next, create two `private` functions called `save` and `load` inside your class:

    ![](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/save_load.png)

    The key to understanding these code is to understand the notice that they are simply wrappers for the following three functions:

    - `SecItemDelete`: deletes a matching entry from the keychain
    - `SecItemAdd`: add an entry to the keychain
    - `SecItemCopyMatching`: find a matching entry from the keychain; notice how we pass in `&data`, the pointer of `data` as an argument so that the `SecItemCopyMatching` will set its value (wow, much C!)

    - The rest of the code is mostly setups and type conversions.

- Then let's create two `public` functions that allow other classes to call on `save` and `load`:

    ![](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/save_load_password.png)

- Great! Lastly, let's add this one line to our `KeyChainHelper` class:

        public static let standard = KeychainHelper()

    This creates what's called a ***Singleton***, a single instance of our class that coordinates across the system. In other word, we don't have to insatiate a new instance of `KeyChainHelper` every time we want to use the keychain, instead we call on `KeyChainHelper.standard`.

- Great! Now the complete code of `KeyChainHelper.swift` should look something like this:

    ![](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/keychain_class.png)

---

### Part II: Log In / Create:

With a working keychain wrapper, let's make our `loginButton` and `createButton` functional as heck. Move to `ViewController.swift` in your Navigator! We'll work only this file for the rest of this tutorial.

- First, let's write an alert function that shows a pop-up message for situations say when a user enters the wrong password. Add the following function to your ViewController class:

    ![](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/alert.png)

    Notice how we wrapped our codes in `DispatchQueue.main.async`? The `DispatchQueue.main` asynchronously runs our code in the main thread, since we don't want any background process to clog up our UI. This will come in handy later when we use TouchID, the background process of which can be quite slow!

- Next, let's write a function `loadData()` that will be called when the user successfully log in. For now, let's make it print out "SUCCESS!"

        func loadData() {
            print("SUCCESS!")
        }

- Next, let's write the functions `login()` and `create()`:

    First, add this line of code to your class:

        let keychain = KeychainHelper.standard

    As we've talked about before, this lets us work with a Singleton. Once you've done this, write the following codes:

    ![](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/login_create.png)

    In `login()`, we check if an account is found under `username`. Recall that we set `contentsOfKeychain` to `nil` if nothing was found in a query. If an account if found, we check if `password` matches and respond correspondingly.

    In `create()`, we simply save the account/username and overwrite any previous entry. (*Would you do this in a real app? What would you change it to?*)

- Cool beans! Now call the functions in your `IBActions` and we're ready to move on to the next section:

    ![](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/login_IB.png)

    You can test your code at this point. See if "SUCCESS" is printed onto your console after creating and logging in.

---

### Part III: TouchID

Once you have experienced logging in with a finger, you don't want to go back to two fingers. TouchID is a great feature that improves the user experience of your landing page.

**Overview**

- Apple's framework called Local Authentication allows you to authenticate a user using local fingerprints. The framework uses one crucial function:

        func evaluatePolicy(policy: LAPolicy, localizedReason localizedReason: String!, reply: ((Bool, NSError!) -> Void)!)

    The function not only authenticates the user, it also checks the various possibilities for error. Some devices may not support TouchID and so on.

**Implementation**

- Add the following code to your `ViewController` class:

    First, add this line to the top of your file:

        import LocalAuthentication

    This imports the framework. Next, add the following function inside your class:

    ![](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/touch_ID.png)

    And then update our `touchButtonTouched` function to call on `authenticateUser()`:

        @IBAction func touchButtonTouched(_ sender: Any) {
            authenticateUser()
        }

    Awesome, now let's analyze our code line by line!

- `let context : LAContext = LAContext()` stores the current device authentication context. You need this object to request for a TouchID authentication.
- We need a `NSError` object to store future errors and a localized string to inform the user why you want their fingerprints.

        var error : NSError?
        let localizedReasonString : String = "Use your fingerprint to access your vault."

- `canEvaluatePolicy()` returns a boolean indicating whether the device supports TouchID:

        guard context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            showAlert(message: "Your device does not support TouchID, try log in with password.")
            return
        }

    Think of `guard` as a `if then` statement with nothing inside the `if{ }` block.

- Finally, we call `evaluatePolicy()` with a callback block:

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReasonString) { (sucess, error) in
                // Our callback block
        }

    Think of our callback block as a function that takes in two arguments, `sucesss: Bool`, and `error: Error`.

- Inside our callback block, we check if we've successfully authenticated our user. If YES, we call `loadData()` in the main thread, if NO, we check to see what type of error we received:

        if (sucess) {
            DispatchQueue.main.async {
                self.loadData()
            }
        } else {
            if error != nil {
                switch error!.\_code {
                case LAError.Code.userCancel.rawValue:
                    break
                case LAError.Code.userFallback.rawValue:
                    break
                default:
                    self.showAlert(message: "Something went wrong...")
                }
            }
        }

    Note that we only handled two types of error, `userCancel` and `userFallback`, and called `showAlert()` in all other cases. You could do something different and be more creative with error handling, for example, make changes to the UI. There're really only three cases that we need to care about:

    - `systemCancel`: system stopped the authentication
    - `userCancel`: user canceled
    - `userFallback`: user decided to use password instead


- To test out TouchID in a simulator, you could go to ***Hardware*** -> ***TouchID*** -> ***Toggle Enrolled State*** and press either ***Matching Touch*** or ***Non-matching Touch***

---

### Part III: Some Final Touch on UI

Tip: always care about your user's experience.

- A BIG problem you might not be able to catch when testing in the simulator in that the keyboard does not go away even after you pressed "return" or a button. Imagine hopelessly staring at a keyboard that blocked half of your screen for evermore. Let's fix this:

    First, make our `ViewController` class a subclass of `UITextFieldDelegate`:

        class ViewController: UIViewController, UITextFieldDelegate {

    Then, add the following code in your `viewDidLoad()` function:

        usernameTextfield.delegate = self
        passwordTextfield.delegate = self

    And write the following two functions:

         func textFieldShouldReturn(_ textField: UITextField) -> Bool {
             hideKeyboard()
             return true
         }

         func hideKeyboard() {
             usernameTextfield.resignFirstResponder()
             passwordTextfield.resignFirstResponder()
         }

    Finally, call `hideKeyboard()` in our `IBActions` functions:

        @IBAction func touchButtonTouched(_ sender: Any) {
            hideKeyboard()
            authenticateUser()
        }
        @IBAction func logInButtonTouched(_ sender: Any) {
            hideKeyboard()
            login(username: usernameTextfield.text!, password: passwordTextfield.text!)
        }
        @IBAction func createButtonTouched(_ sender: Any) {
            hideKeyboard()
            createAccount(username: usernameTextfield.text!, password: passwordTextfield.text!)
        }

    This effectively hides resign the keyboard whenever a button is pressed or return is pressed.

- Another BIG problem is that we don't want the user to be able to log in or create when either username is empty or password is empty! To fix this, we disable the buttons until we detect some inputs:

    Add the following code in your `viewDidLoad()` function:

        LogInButton.isEnabled = false
        CreateButton.isEnabled = false
        passwordTextfield.isSecureTextEntry = true

        NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: passwordTextfield, queue: .main) { (notification) in
            self.setButton()
        }
        NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: usernameTextfield, queue: .main) { (notification) in
            self.setButton()
        }

    And then write the function `setButton`:

        func setButton() {
            if (usernameTextfield.text != "" && passwordTextfield.text != "") {
                LogInButton.isEnabled = true
                CreateButton.isEnabled = true
            } else {
                LogInButton.isEnabled = false
                CreateButton.isEnabled = false
            }
        }

    Awesome! Test the code to see if it works.

- Lastly, our `loadData()` doesn't really do anything, which is very awkward. Let's add some code to the function:

        func loadData() {    
            UIView.animate(withDuration: 0.7, animations: {
                self.TouchButton.alpha = 0
                self.CreateButton.alpha = 0
                self.LogInButton.alpha = 0
                self.usernameTextfield.alpha = 0
                self.passwordTextfield.alpha = 0
                self.vaultLabel.alpha = 0
            }) { (complete) in
                self.vaultLabel.text = "You are now inside the CocoaVault! Money! So much money! Cocoanuts! So much Cocoanuts!"
                self.vaultLabel.alpha = 1
            }
        }

    Now, you have a vault!

    Great job! Your `ViewController.swift` should look something like this:

    ![](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/whole_1.png)
    ![](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/whole_2.png)
    ![](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/Images/whole_3.png)

---

### Thanks!
