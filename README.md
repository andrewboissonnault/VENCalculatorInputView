Alternate keyboard for VENCalculatorInputView
=========

This fork of VENCalculatorInputView 1.4 has option for alternate keyboard with extra buttons (and delegate methods):

![Alternate VENCalculatorInputView layout](https://cloud.githubusercontent.com/assets/747340/10244493/5b00eb88-6908-11e5-9e6a-6b34c2de1af3.png "Modified VENCalculatorInputView layout")

Keyboard has different layout (to avoid need for toolbar) and works on all size devices
* Change sign button - changes sign of current result in calculator
* Confirm buttom - evaluates expression in textfield, updates result and hides keyboard

To use 
```obj-c
VENCalculatorInputTextField *textField = [[VENCalculatorInputTextField alloc] initWithFrame:frame keyboardStyle:VENCalculatorInputViewStyleWithEquals];
```

There are extra corresponding ```<VENCalculatorInputViewDelegate>``` methods added as well (should be implemented in your delegate if you are using just input view).

Note: Library has not been tested (but should work as far as I'm concerned) on iOS5 as the original [VENCalculatorInputView](https://github.com/venmo/VENCalculatorInputView). Therefore for this fork expected iOS version - 7.0

P.S. This fork has non-compatible changes with latest VENCalculatorInputView versions (after 1.4) so be aware.


VENCalculatorInputView
=========

[![Build Status](https://travis-ci.org/venmo/VENCalculatorInputView.png?branch=master)](https://travis-ci.org/venmo/VENCalculatorInputView)

VENCalculatorInputView is the calculator keyboard that is used in the [Venmo](https://venmo.com/) iOS app.
Available for iOS 5 and beyond. Enjoy.

![alt text](http://i.imgur.com/VWgymjH.gif "VENCalculatorInputView demo")

Installation
----

The easiest way to get started is to use [CocoaPods](http://cocoapods.org/). Just add the following line to your Podfile:

```ruby
pod 'VENCalculatorInputView', '~> 1.4'
```

Sample Usage
----
You can choose to use just ```VENCalculatorInputView``` (only the keyboard) and define your own behavior or use ```VENCalculatorInputTextField``` (keyboard + text field with money calculation built in).

### Using just the calculator keyboard

#### 1. Set the input view.
Find the ```UITextField``` or ```UITextView``` that you want to display the keyboard and set its ```inputView``` to an instance of ```VENCalculatorInputView```.

```obj-c
myTextField.inputView = [VENCalculatorInputView new];
```

This will have ```VENCalculatorInputView``` display when ```myTextField``` becomes ```firstResponder``` instead of the system keyboard.

#### 2. Implement the ```<VENCalculatorInputViewDelegate>``` methods.

First, have a class implement the ```<VENCalculatorInputViewDelegate>``` protocol and set ```myTextField.inputView.delegate``` to an instance of that class.

Next, implement the delegate method that handles keyboard input:

```obj-c
- (void)calculatorInputView:(VENCalculatorInputView *)inputView didTapKey:(NSString *)key {
    NSLog(@"Just tapped key: %@", key);
    // Handle the input. Something like [myTextField insertText:key];
}
```

Finally, implement the delegate method that handles the backspace key:

```obj-c
- (void)calculatorInputViewDidTapBackspace:(VENCalculatorInputView *)calculatorInputView {
    NSLog(@"Just tapped backspace.");
    // Handle the backspace. Something like [myTextField deleteBackward];
}
```

Try it!

You can read more about custom keyboards in [Apple's documentation](https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/InputViews/InputViews.html).

### Using the calculator text field (optimized for money calculation)

All you need to do is use ```VENCalculatorInputTextField``` instead of ```UITextField``` and use it like normal text field. It will automagically handle the input and make calculations. Take a look at out our ```VENCalculatorInputViewSample``` project.

Localization
------

Different regions use different symbols as their decimal separator (e.g. ```.```, ```,```). By default, ```VENCalculatorInputView``` and ```VENCalculatorInputTextField``` use the current locale of the device. You can change it by setting the ```locale``` property.

Testing
------

We've written some tests. You can run them by opening the project in Xcode and hitting `Command-U`.

Contributing
------------

We'd love to see your ideas for improving this library! The best way to contribute is by submitting a pull request. We'll do our best to respond to your patch as soon as possible. You can also submit a [new GitHub issue](https://github.com/venmo/VENCalculatorInputView/issues/new) if you find bugs or have questions. :octocat:

Please make sure to follow our general coding style and add test coverage for new features!
