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

Add a stylesheet to your application

```xml
<Stylesheet>
    <Style name="textHeaderStyle">
        <Setter property="text-color" value="#333333" />
        <Setter property="font" value="SegoeUI-Bold 20" />
    </Style>
    <Style name="textBodyStyle">
        <Setter property="text-color" value="#333333" />
        <Setter property="font" value="SegoeUI-Light 17" />
    </Style>
    <Style name="pageStyle">
        <Setter property="background-color" value="#F1F1F1" />
        <Setter property="border-color" value="#0000FF" />
        <Setter property="border-width" value="10" />
        <Setter property="corner-radius" value="0" />
    </Style>
    <Style name="buttonStyle">
        <Setter property="background-color" value="#333333" />
        <Setter property="text-color" value="#F1F1F1" />
        <Setter property="border-color" value="#FF0000" />
        <Setter property="border-width" value="1" />
        <Setter property="corner-radius" value="5" />
        <Setter property="font" value="SegoeUI-Light 17" />
    </Style>
</Stylesheet>
```
Load the style sheet

```Objective-C
NSURL *url = [[NSURL alloc] initWithXAML:url:[[NSBundle mainBundle] 
                         pathForResource:@"dark-stylesheet"
                                  ofType:@"xaml"]];

iXStylesheet *stylesheet = [[iXStylesheet alloc] initWithContentsOfURL:url];

[[UIApplication sharedApplication] setStylesheet:stylesheet];
```

Open Interface Builder, click on the control you want to style and open the identity inspector

![Interface Builder](https://github.com/rudigrobler/iXAML/blob/master/Documentation/interface_builder_UILabel_identity_inspector_style_textHeaderStyle.jpg?raw=true)

Add a 'style' User Defined Runtime Attributes and iXAML will do the rest!

## Similar

[NUI](https://github.com/tombenner/nui) by Tom Benner
> NUI is a drop-in UI kit for iOS that lets you style UI elements using a style sheet, similar to CSS. It lets you style an entire app in minutes.

Very cool library with CSS and Interface Builder support but heavy use of swizzling.

* https://github.com/cssapply/CSSApply
* https://github.com/juliengomes/iCSS
* https://github.com/facebook/three20
* https://github.com/jverkoey/nimbus

by [@rudigrobler](http://twitter.com/rudigrobler/)