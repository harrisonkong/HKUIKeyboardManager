# HKUIKeyboardManager
#### HK Keyboard Manager

## VERSION HISTORY

  1.0.0         Initial release

## INTRODUCTION

Showing and hiding the on-screen keyboard is always a headache in mobile application development. So much code and they are all over different places in the project. And you have to do it in every project.

This keyboard manager will come to your rescue and provide many options to customize how its function. Only a few lines of code will saves you hours of work in every project that uses text input. It also provides a few bonus functions.

To see it in action and play with its options, head to https://github.com/harrisonkong/HKUIKeyboardManagerDemo for a demo application.

<img src='https://github.com/harrisonkong/HKUIKeyboardManager/blob/master/s1.jpg' width="200" /> <img src='https://github.com/harrisonkong/HKUIKeyboardManager/blob/master/s2.jpg' width="200" /> <img src='https://github.com/harrisonkong/HKUIKeyboardManager/blob/master/s3.jpg' width="200" />

## HOW DOES IT WORK

The diagrams here explain how it works.

There are two classes, `HKUIKeyboardManager` is for `UIView` that do not scroll. For this version, it simply hides and shows the keyboard.

<img src='https://github.com/harrisonkong/HKUIKeyboardManager/blob/master/d1.jpg' width="500" />

Another one `HKUIKeyboardManagerScrollable` is for `UIScrollView` and descendants such as `UICollectionView` and `UITableView`. For this verison, it is also capable or scrolling the active text field into better view as well as adding inset to the content behind it so that the user can scroll to what's behind the keyboard.

<img src='https://github.com/harrisonkong/HKUIKeyboardManager/blob/master/d2.jpg' width="500" />

It works by keeping track of a list of UITextFields or UITextViews (or their descendants) that you register with it. And it also use a few gesture recognizers to capture taps and other gestures (They do not interfere with other gesture recognizers that you might need to use in your code). It is then able to tell all the editable fields to end editing when taps are detected outside of any text fields and views, resulting in hiding of the keyboard. Hitting the enter key on single line text fields (UITextFields) will also hide the keyboard.

In addition, for the scrollView version, it also has an option (default is enabled) to scroll the active text field into the optimal view when it is tapped.

## INSTALLATION

The best way is to use CocoaPod. Here is a sample Podfile:


  platform :ios, '13.0'

  target 'MyTargetName' do

    use_frameworks!

    # some other pods that your project need...

    pod 'HKUIKeyboardManager', '~> 1.0.0'

  end


Alternatively, you can just include this files in your project:

```
  HKUIKeyboardManager.swift
  HKUIKeyboardManagerScrollable.swift
  UIView+HKUtilities.swift
```

## USAGE

Don't forget to import it first if you are using the CocoaPod option:

```
  import HKUIKeyboardManager
```

### 1. Initialize and register text fields ###
    
```
 
       let kbManager : HKUIKeyboardManagerScrollable?
       .
       .
       .
 
       override func viewDidLoad() {
         super.viewDidLoad()
   
           // code ...

           kbManager = HKUIKeyboardManager.init(ownerView: scrollView, outermostView: view)
   
           kbManager?.registerEditableField(nameTextField)
           kbManager?.registerEditableField(addressTextField)
 
          // more code ...
          
        }
        
```

(Optional Steps:)
 
### 2. Call from the overridden prepare if you want to hide the keyboard when seguing to another screen (dismissDuringSegue == true) ###
  
```
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
            // some code ...

            KBManager?.preparingSegue()
  
           // some other code ...
       }

```

### 3. Call from the overridden viewWillTransition if you want to hide the keyboard during device rotation (dismissDuringDeviceRotation == true) ###

```
       override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
   
          super.viewWillTransition(to: size, with: coordinator)
   
          // do whatever ...
   
          KBManager?.viewWillTransition()
       }
```

### 4. If you would like the keyboard to be dismissed upon custom gestures, register your own custom gesture recognizers. You can add additional action targets for these gesture recognizers but do not add them to any views or assign delegates to them. The keyboard manager will handle that. ###
    
```
         .
         .
       tripleTapRecognizer.addTarget(self, action: #selector(handle3Taps(_:)))
       KBManager?.registerCustomGestureRecognizer(tripleTapRecognizer)
         .
         .
       
```
 
### 5. Change other user options as needed: ###

      option                      default     meaning for true
      ______________________________________________________________________
 
      dismissOnTapGestures        true        if taps are detected outside
                                              of keyboard and not in text
                                              fields, keyboard will dismiss
 
      dismissOnPanGestures        true        if pans are detected outside
                                              of keyboard and not in text
                                              fields, keyboard will dismiss
 
                                  false       (set to false by default for
                                              HKUIKeyboardManagerScrollable to
                                              allow scrolling)

      dismissOnPinchGestures      true        if pinches are detected outside
                                              of keyboard and not in text
                                              fields, keyboard will dismiss
 
      dismissOnRotationGestures   true        if rotation gestures are detected
                                              outside of keyboard and not in
                                              text fields, keyboard will dismiss
 
      dismissDuringSegue          true        dismiss the keyboard when a segue
                                              is being prepared, only set to
                                              false if the view does not rotate.
                                              Subject to automatically setting
                                              to true if the view rotates and
                                              this is set to false.
                                              See development notes.
 
      dismissDuringDeviceRotation true        dismiss the keyboard when the
                                              device is rotated, only set to
                                              false if the view does not segue
                                              to another screen.
                                              Subject to automatically setting
                                              to true if a segue is prepared and
                                              this is set to false.
                                              See development notes.
 
      keepActiveFieldInViews      true        (HKUIKeyboardManagerScrollable
                                              only)
                                              if the active text field is
                                              obscured by the keyboard when it
                                              first receive focus, it will be
                                              scrolled to above the keyboard
                                              
                                              but if doing so will cause the
                                              top of the field to extend above
                                              the top of the screen, it will
                                              simply be scrolled down so that
                                              its top is just under the top of
                                              the screen with a small margin.
                                              
## CUSTOMIZATION

If you are interested in modifying the code, please read the development notes in a separate file for issues that you should be aware of.


     
