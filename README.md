# iXAML

[UIAppearance](http://nshipster.com/uiappearance/) allows the appearance of views and controls to be consistently defined across the entire application.

If UIAppearance is so great, why do we need iXAML?

A major shortcoming of UIAppearance is that style rules are imperative, rather than declarative. That is, styling is applied at runtime in code, rather than being interpreted from a list of style rules.

iXAML enable loading (and applying) declarative stylesheets!

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

Open Interface Builder and click on the UIView (control) you want to style

![Interface Builder](https://github.com/rudigrobler/iXAML/blob/master/Documentation/SetStyleInIB.jpg?raw=true)

Add a 'style' User Defined Runtime Attributes and iXAML will do the rest!

## Similar

* https://github.com/tombenner/nui
* https://github.com/cssapply/CSSApply
* https://github.com/juliengomes/iCSS
* https://github.com/facebook/three20
* https://github.com/jverkoey/nimbus

by [@rudigrobler](http://twitter.com/rudigrobler/)