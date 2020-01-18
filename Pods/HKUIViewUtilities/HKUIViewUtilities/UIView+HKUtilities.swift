//
//  UIView+HKUtilities.swift
//  UIView HK Utilities Methods Extension
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

//  Version: 1.0.0
//
//  Version History
//  -----------------------------------------------------------------
//  1.0.0     - 2020/01/17 initial release

import UIKit

extension UIView {
  
    // MARK: - Public Methods
    // MARK: -
  
    public final func contentMinBox() -> CGSize {

      //  example:
      //
      //  parentView
      //  +--------------------------------+
      //  |      +...................+     |
      //  |      .     +----------+  .     |
      //  |      .     |  subview |  .     |
      //  |      . +---------+    |  .<---this is the minimum box that will fit
      //  |      . | subview |    |  .    all the subviews and will be returned
      //  |      . |    +----------+ .     |
      //  |      . |    | subview  | .     |
      //  |      . |    |          | .     |
      //  |      . |    +----------+ .     |
      //  |      . |         |       .     |
      //  |      . +---------+       .     |
      //  |      .  +--------------+ .     |
      //  |      .  |  subview     | .     |
      //  |      .  +--------------+ .     |
      //  |      +...................+     |
      //  |                                |
      //  +--------------------------------+
      
        var minBox = CGRect()
      
        for subview in self.subviews {
            minBox = minBox.union(subview.frame)
        }
      
        return minBox.size
    }
  
    public final func isLandscape() -> Bool {
        return !isPortrait()
    }
  
    public final func isPortrait() -> Bool {
        return frame.size.width <= frame.size.height
    }
    
    public final func longerEdgeLength() -> CGFloat {
        return isLandscape() ? frame.size.width : frame.size.height
    }
    
    public final func shorterEdgeLength() -> CGFloat {
        return isLandscape() ? frame.size.height : frame.size.width
    }
  
}
