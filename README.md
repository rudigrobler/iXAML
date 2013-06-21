# iXAML

[UIAppearance](http://nshipster.com/uiappearance/) allows the appearance of views and controls to be consistently defined across the entire application.

**If UIAppearance is so great, why do we need iXAML?**

A major shortcoming of UIAppearance is that styles are imperative (applied it runtime in code), not declarative.

iXAML adds support for declarative stylesheets

## Design goals of iXAML

* Interface Builder support
* Switching themes at runtime
* Support multiple stylesheet formats (plist, xaml, css, less, etc.)
* Be light-weight and non-intrusive
* No overriding of framework methods
* No swizzling
* No custom base UIView or UIViewController

## Styling

Add a stylesheet to your application using either [XAMLite](https://github.com/rudigrobler/iXAML/wiki/Stylesheet-using-XAMLite) or [plist](https://github.com/rudigrobler/iXAML/wiki/Stylesheet-using-plist)

Open Interface Builder, click on the control you want to style and open the identity inspector

![Interface Builder](https://github.com/rudigrobler/iXAML/blob/master/Documentation/interface_builder_UILabel_identity_inspector_style_textHeaderStyle.jpg?raw=true)

Add a 'style' User Defined Runtime Attributes and iXAML will do the rest!

## Similar Projects

[Here](https://github.com/rudigrobler/iXAML/wiki/Similar-Projects) is a list of similar and/or related projects

* * *
by [@rudigrobler](http://twitter.com/rudigrobler/)