# HKUIKeyboardManager
   
### DEVELOPMENT NOTES
   
Several bugs at the iOS level were discovered duriung development leading to some design considerations. These bugs have been around for a while. But there are no guarantee if they will behave the same in future iOS releases.

  1.  Sometimes it is possible to get two UIResponder.keyboardWillShowNotification or `UIResponder.keyboardWillHideNotification` in succession. We do not want to process two in a row as it will set the insets twice. (e.g., when something is typed into a text field and the return key is tapped.)
  
      A state instance variable keyboardWasShowing is set up to track to see if the keyboard is currently showing. (We check the same for the hide notifications, too but it is really not necessary because when we are hiding the keyboard, we simply set the insets to 0's.)
      
      For example, if we get a `willShow` notification and the variable is true,
we ignore the notification.

  2. Keyboard height passed in the notification is very inconsistent but the first one received during either orientation is correct. So we save it for future use and ignore the future values unless they are bigger than the one saved.

      => `maxPortraitKeyboardHeight`
      
      => `maxLandscapeKeyboardHeight`

      This usually only occurs when the device is rotated while another screen is on top of the current one. Therefore, by default, the keyboard is dismissed to reset the system during segue preparation. But it can be overridden if rotation is not allowed for the screen.

      ==> Set `dismissKeyboardDuringSegue` to false.

      During device rotation, if we find this was set to false, we will set
      it to true as a safety measure!

  3. Related to 2. above, by default, we dismiss the keyboard when the device is rotated. But it can be overridden if the screen does not spawn another other screens.

      ==> Set `dismissDuringDeviceRotation` to false.

      During segue prepration, if we find this was set to false, we will set it to true as a safety measure!

  4. These classes listen to TextEditingDidBegin, TextEditingdidEnd, keyboardWillShow and keyboardWillHide notifications
  
      `UITextField` and `UITextView` do not follow the same notification sequence when it is entering and exiting edit mode
 
```
      UITextField                 UITextView
      ------------------          -------------------
      textEditingDidBegin         keyboardWillShow
      keyboardWillShow            textEditingDidBegin
      keyboardWillHide            keyboardWillHide
      textEditingWillEnd          textEditignWillEnd
 ```

   During the keyboard hide/show notifications we only have the keyboard frame dimension and not the active editing field and vice versa.
   
   Therefore it is necessary to save the active field and keyboard frame as instance variables.

