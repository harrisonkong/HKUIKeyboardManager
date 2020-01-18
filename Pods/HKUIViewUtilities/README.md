# HKUIViewUtilities
#### UIView HK Utilities Methods Extension

## SUMMARY

This module extends UIView with utility methods. This is a required module for many other Swift HK modules.

## PUBLIC UTILITY METHODS AVAILABLE

All the methods can be called by any descendants of UIView. Public methods can be called by any code in the project.

### public final func contentMinBox() -> CGSize ###

Returns the minimum box size that will fit all the subviews.

### public final func isLandscape() -> Bool ###

Returns true if the width > height. Otherwise, returns false.

### public final func isPortrait() -> Bool ###

Returns true if the width <= height. Otherwise, returns false.

### public final func longerEdgeLength() -> CGFloat ###

Returns the width if width > height. Otherwise, return the height.

### public final func shorterEdgeLength() -> CGFloat ###

Returns the height if width <= height. Otherwise, return the width.

## INSTALLATION

This will be automatically included by other HK modules or CocoaPods.

### TO USE IT IN YOUR OWN PROJECT

Just include the UIView+HKUILayoutShorthands.swift file in your project or use CocoaPod. Don't forget to import the module if you are using CocoaPod:

```
  import HKUIViewUtilities
```
