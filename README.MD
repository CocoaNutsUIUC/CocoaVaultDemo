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

![demo](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/GIFs/demo.gif)

---

### Xcode Overview:
*(Skip if you're familiar with Xcode)*

- Xcode is an integrated development environment (IDE) which contains all the tools you need to build an iOS, watchOS, macOS, or tvOS app.
- On the left side, you have the ***Navigator***; in the middle, you have the ***Editor***; on the right side, you have various ***Utilities***; on the top, you have the ***toolbar***.
- Xcode uses ***storyboards*** to lay out the app's user interface. It automatically generates a XML document, so you won't have to. 
- Because we love iOS devices of all shapes and sizes, Xcode's ***storyboards*** use what's called ***Auto Layout*** to dynamically calculate the size and position of all the views in your app. You just have to create constraints on those  views.
- Press `Command + B` to build your project. Press `Command + R` to run your project in a simulator. Press `Command + shit + K` to clean your built codes. These shortcuts will come in handy in the future!

---


### Project Set Up

1. Open Xcode 8.0+, click on ***"Create a new Xcode project"*** and select ***"Single View Application"***, then click next.
2. Fill in the name ***"CocoaVault"*** (or some other name if you're feeling rebellious) and click next.

![create_projects](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/GIFs/create_project.gif)

---

### Storyboard Set Up

Steve is a minimalistic when it comes to design. So we'll set up our app to be as simple and easy-to-use as humanly possible, which is often a good design practice!

3. Go to ***Main.storyboard*** in your Navigator, here's where we set up the UI for our app.
4. Drag one ***Label***, two ***Text Field***, and three ***Button*** onto your fake iPhone screen in the middle. It doesn't matter where *exactly* you put them right now. Once we add some constraints, they'll fall in place pretty neatly.

![drag_views](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/GIFs/darg_views.gif)

4. Rename our label to "CocoaVault" and set the font to **bold**, and rename the left button to "***Log In***", the right button to "***Touch***", and the bottom button to "***Create New Vault***".

![rename_views](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/GIFs/rename_views.gif)

5. Add the following constraints to our view:

(*Now, I admit that this step is kinda confusing ... and can be easily messed up, so if you run into any problem, place ask us to help!*)

(**Note: use `Control` + drag from one view to another view to create constraints between them!**)

Do this first: ![auto_layout](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/GIFs/auto_layout.gif)

Do this after: [auto_layout_2](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/GIFs/auto_layout_2.gif)

**After this step, you should have the following constraints on each of our views:**




Perfect! Now, we just need to make these graphical ***buttons***, ***textfields***, and ***label*** manifest in our code. We do so by creating ***outlets***!

6. In your ***Main.storyboard***, open the Assistance Editor (*the intersecting circles icon upper left corner*), select `ViewController.swift` and *Control drag* your views to inside the class.

![create_outlets](https://github.com/sstevenshang/CocoaVaultDemo/blob/master/GIFs/create_outlets.gif)

Notice that we created six `IBOutlets` and three `IBActions`. The `IBActions` are event-triggered functions that will let us respond to user interactions.

---

### Coding Password Authenticator

Cool! Now we're ready to code.

Let's first create an alert function that let us communicate with the users when they enter a wrong password and so on:

Add the following code to your ViewController class:
