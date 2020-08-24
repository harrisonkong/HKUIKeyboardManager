//
//  HKUIKeyboardManager.swift
//  HK Keyboard Manager
//

///  MIT License
///
///  Copyright (c) 2020 Harrison Kong
///
///  Permission is hereby granted, free of charge, to any person obtaining a copy
///  of this software and associated documentation files (the "Software"), to deal
///  in the Software without restriction, including without limitation the rights
///  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell/
///  copies of the Software, and to permit persons to whom the Software is
///  furnished to do so, subject to the following conditions:
///
///  The above copyright notice and this permission notice shall be included in all
///  copies or substantial portions of the Software.
///
///  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
///  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
///  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
///  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
///  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
///  SOFTWARE.

//  Version: 1.1.0
//
//  Version History
//  -----------------------------------------------------------------
//  1.0.0     - 2020/01/19 - initial release
//  1.1.0     - 2020/08/24 - add unregisterEditableField( )
//                         - documentation update

//  Dependencies
//  -----------------------------------------------------------------
//  HKUIViewUtilities       >= 1.0.0

//  How To Use
//  -----------------------------------------------------------------

/*
    NOTE: If using Interface Builder, the keyboard dismiss mode of UIScrollView,
          UICollectionView, UITableView and any descendent of UIScrollView will
          be set to .none by this class, overriding the settings in interface
          builder
 
    (Use HKUIKeyboardManager for non-scrollable views,
     use HKUIKeyboardManager for scrollable views such as UIScrollView, UITableView, UIC  ollectionView)
 
    1. Initialize and register text fields and text views
 
       var kbManager : HKUIKeyboardManager?
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


    (Optional Steps:)
 
    2.  Unregister text fields or text views that you do not want to include
        or those that you are about to destroy:
 
        kbManager?.unregisterEditableField(nameTextField)
 
    3. Call from the overridden prepare if you want to hide the keyboard
       when seguing to another screen (dismissDuringSegue == true)
  
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
           // some code ...

           kbManager?.preparingSegue()
  
           // some other code ...
       }

    4. Call from the overridden viewWillTransition if you want to hide the
       keyboard during device rotation (dismissDuringDeviceRotation == true)
 
       override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
   
          super.viewWillTransition(to: size, with: coordinator)
   
          // do whatever ...
   
          kbManager?.viewWillTransition()
       }

    5. If you would like the keyboard to be dismissed upon custom gestures,
       register your own custom gesture recognizers. You can add additional
       action targets for these gesture recognizers but do not add them to
       any views or assign delegates to them. The keyboard manager will handle
       that.

       ...
       tripleTapRecognizer.addTarget(self, action: #selector(handle3Taps(_:)))
       kbManager?.registerCustomGestureRecognizer(tripleTapRecognizer)
       ...
 
    6. Change other user options as needed:
 
       property                    default     meaning if it is true
       -------------------------------------------------------------------------
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
                                               See development notes below.
 
       dismissDuringDeviceRotation true        dismiss the keyboard when the
                                               device is rotated, only set to
                                               false if the view does not segue
                                               to another screen.
                                               Subject to automatically setting
                                               to true if a segue is prepared and
                                               this is set to false.
                                              See development notes below.
 
       keepActiveFieldInViews      true        (HKUIKeyboardManagerScrollable
                                               only)
                                               if the active text field is
                                               obscured by the keyboard when it
                                               first receive focus, it will be
                                               scrolled to above the keyboard.
 
                                               but if doing so will cause the
                                               top of the field to extend above
                                               the top of the screen, it will
                                               simply be scrolled down so that
                                               its top is just under the top of
                                               the screen with a small margin.
*/
     
//  Development Notes
//  -----------------------------------------------------------------

/*
    Several bugs at the iOS level were discovered duriung development leading
    to some design considerations. These bugs have been around for a while. But
    there are no guarantee if they will behave the same in future iOS releases.

    1. Sometimes it is possible to get two
      UIResponder.keyboardWillShowNotification or
      UIResponder.keyboardWillHideNotification in succession. We do not
      want to process two in a row as it will set the insets twice. (e.g.,
      when something is typed into a text field and the return key is tapped.)
      A state instance variable keyboardWasShowing is set up to track to see
      if the keyboard is currently showing. (We check the same for the hide
      notifications, too but it is really not necessary because when we are
      hiding the keyboard, we simply set the insets to 0's.)

      For example, if we get a willShow notification and the variable is true,
      we ignore the notification.

    2. Keyboard height passed in the notification is very inconsistent but the
      first one received during either orientation is correct. So we save it
      for future use and ignore the future values unless they are bigger than
      the one saved.

      => maxPortraitKeyboardHeight
      => maxLandscapeKeyboardHeight

      This usually only occurs when the device is rotated while another screen
      is on top of the current one. Therefore, by default, the keyboard is
      dismissed to reset the system during segue preparation. But it can be
      overridden if rotation is not allowed for the screen.

      ==> Set dismissKeyboardDuringSegue to false.

      During device rotation, if we find this was set to false, we will set
      it to true as a safety measure!

    3. Related to 2. above, by default, we dismiss the keyboard when the device
      is rotated. But it can be overridden if the screen does not spawn another
      other screens.

      ==> Set `dismissDuringDeviceRotation` to false.

      During segue prepration, if we find this was set to false, we will set
      it to true as a safety measure!

    4. These classes listen to TextEditingDidBegin, TextEditingdidEnd,
      keyboardWillShow and keyboardWillHide notifications
 
      UITextField and UITextView do not follow the same notification sequence
      when it is entering and exiting edit mode
 
      UITextField                 UITextView
      ------------------          -------------------
      textEditingDidBegin         keyboardWillShow
      keyboardWillShow            textEditingDidBegin
      keyboardWillHide            keyboardWillHide
      textEditingWillEnd          textEditignWillEnd
 
      During the keyboard hide/show notifications we only have the keyboard
      frame dimension and not the active editing field and vice versa
 
      Therefore it is necessary to save the active field and keyboard frame
      as instance variables
 
*/

import UIKit
import HKUIViewUtilities

public class HKUIKeyboardManager : NSObject {
  
    // MARK: - Properties
    // MARK: -

    var textFieldsAndViews         : Set<UIView> = []
    var tapGestureRecognizer       = UITapGestureRecognizer()
    var panGestureRecognizer       = UIPanGestureRecognizer()
    var pinchGestureRecognizer     = UIPinchGestureRecognizer()
    var rotationGestureRecognizer  = UIRotationGestureRecognizer()
    var ownerView                  : UIView?
    var outermostView              : UIView?
  
    public var dismissOnTapGestures      = true
    public var dismissOnPanGestures      = true
    public var dismissOnPinchGestures    = true
    public var dismissOnRotationGestures = true
  
    // only set to false if rotation disabled
    // always set to true if rotation is allowed
    public var dismissDuringSegue = true
    
    // only set to false if it does not jump to other screen
    // always set to true if other screens might pop up
    public var dismissDuringDeviceRotation = true
  
    // MARK: - IB Actions
    // MARK: -
  
    @IBAction func handleCustomGesture(_ sender: UIGestureRecognizer) {
        endEditingInAllTextFields()
    }
  
    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        if dismissOnPanGestures { endEditingInAllTextFields() }
    }

    @IBAction func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        if dismissOnPinchGestures { endEditingInAllTextFields() }
    }
 
    @IBAction func handleRotationGesture(_ sender: UIRotationGestureRecognizer) {
        if dismissOnRotationGestures { endEditingInAllTextFields() }
    }
  
    @IBAction func handlePrimaryActionTriggered(_ sender: UITextField) {
        sender.endEditing(true)
    }
  
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        if dismissOnTapGestures { endEditingInAllTextFields() }
    }
  
    // MARK: - Initializers
    // MARK: -
  
    public init(ownerView: UIView, outermostView: UIView) {

        super.init()
      
        // (The outermostView is used to determine if the screen is in portrait
        //  or landscape orientation)
      
        self.outermostView = outermostView
        self.ownerView = ownerView
      
        // add tap gesture handler
      
        tapGestureRecognizer.addTarget(self, action: #selector(handleTapGesture(_:)))
        tapGestureRecognizer.delegate = self
        self.ownerView?.addGestureRecognizer(tapGestureRecognizer)
 
        // add pan gesture handler
      
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        self.ownerView?.addGestureRecognizer(panGestureRecognizer)
      
        // add pinch gesture handler
      
        pinchGestureRecognizer.addTarget(self, action: #selector(handlePinchGesture(_:)))
        pinchGestureRecognizer.delegate = self
        self.ownerView?.addGestureRecognizer(pinchGestureRecognizer)
      
        // add rotation gesture handler
      
        rotationGestureRecognizer.addTarget(self, action: #selector(handleRotationGesture(_:)))
        rotationGestureRecognizer.delegate = self
        self.ownerView?.addGestureRecognizer(rotationGestureRecognizer)
      
        panGestureRecognizer.require(toFail: pinchGestureRecognizer)
        panGestureRecognizer.require(toFail: rotationGestureRecognizer)
        tapGestureRecognizer.require(toFail: pinchGestureRecognizer)
        tapGestureRecognizer.require(toFail: rotationGestureRecognizer)
    }
    
    // MARK: - Private Methods
    // MARK: -
  
    private func endEditingInAllTextFields() {
        for textField in textFieldsAndViews {
          textField.endEditing(true)
        }
    }
  
    func isUITextField(_ object: Any) -> Bool {
        let test = object as? UITextField
        return test != nil
    }

    func isUITextView(_ object: Any) -> Bool {
        let test = object as? UITextView
        return test != nil
    }
    
    // MARK: - Public Methods
    // MARK: -
  
    public func preparingSegue() {
      
        // Call from the overridden prepare if you want to hide the keyboard
        // when seguing to another screen (dismissDuringSegue == true)
      
        /*
       
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
                // some code ...

                HKUIKeyboardManager?.preparingSegue()
       
                // some other code ...
            }

       */
    
        // Rotation while other screen is on top will cause problems
        // Since we are processing segues, let's disable it
        // (see notes 2., 3, and 4. above)
      
        if !dismissDuringDeviceRotation {
          dismissDuringDeviceRotation = true
        }
        
        if dismissDuringSegue {
          endEditingInAllTextFields()
        }
      
    }

    public func registerCustomGestureRecognizer(_ customRecognizer: UIGestureRecognizer) {
   
        // if you have a custom gesture recognizer, use this function to add it
        // create a separate gesture recognizer for this purpose
        // if this gesture happens inside one of the text fields, it will be
        // be ignored just like the tap, pan and pinch gestures
      
        customRecognizer.addTarget(self, action: #selector(handleCustomGesture(_:)))
        customRecognizer.delegate = self
        tapGestureRecognizer.require(toFail: customRecognizer)
        panGestureRecognizer.require(toFail: customRecognizer)
        pinchGestureRecognizer.require(toFail: customRecognizer)
        rotationGestureRecognizer.require(toFail: customRecognizer)
        self.ownerView?.addGestureRecognizer(customRecognizer)
    }
  
    public func registerEditableField(_ field: UIView) {
      
        // register text fields and text views with this class
        //
        // e.g., HKUIKeyboardManager.registerEditableField(txtField)
      
        if !isUITextField(field) && !isUITextView(field) {
          return
        }
        
        textFieldsAndViews.insert(field)
        
        if isUITextField(field) {
          let textField = field as! UITextField
          textField.addTarget(self, action: #selector(handlePrimaryActionTriggered(_:)), for: .primaryActionTriggered)
        }
    }
  
    // HK20200824
    public func unregisterEditableField(_ field: UIView) {
        
        // unregister previously registered text fields and text views with this class
        //
        // e.g., HKUIKeyboardManager.unregisterEditableField(txtField)

        if !isUITextField(field) && !isUITextView(field) {
            return
        }
        
        textFieldsAndViews.remove(field)
      
        if isUITextField(field) {
            let textField = field as! UITextField
            textField.removeTarget(self, action: #selector(handlePrimaryActionTriggered(_:)), for: .primaryActionTriggered)
        }
    }
    
    public func viewWillTransition() {
    
        // Call from the overridden viewWillTransition if you want to hide the
        // keyboard during device rotation (dismissDuringDeviceRotation == true)
      
        /*
       
           override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       
              super.viewWillTransition(to: size, with: coordinator)
       
              // do whatever ...
       
              HKUIKeyboardManager?.viewWillTransition()
       
           }
       
         */
      
        // Rotation while other screen is on top will cause problems
        // Since we are processing rotations, let's disable it
        // (see notes 2., 3., and 4. above)
              
        if !dismissDuringSegue {
            dismissDuringSegue = true
        }
        
        if dismissDuringDeviceRotation {
            endEditingInAllTextFields()
        }
              
    }
    
}

// MARK: -
// MARK: -

extension HKUIKeyboardManager : UIGestureRecognizerDelegate {
  
    // MARK: UIGestureRecognizerDelegate Protocol
  
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        guard let touchedView = touch.view else { return true }
        
        // ignore (return false) if the gesture happened in one of the
        // editable fields
      
        return !textFieldsAndViews.contains(touchedView)
    }
  
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
