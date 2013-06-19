# iXAML

iXAML is a proof of concept to add VERY basic binding & styling support for iOS. The API design is based on XAML.

## Design goals of iXAML

* Be light-weight and non-intrusive
* No overriding of framework methods
* No swizzling

## Styling

Add the following stylesheet to your application

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
Load the style sheet from the main bundle

```Objective-C
NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] 
                                pathForResource:@"dark-stylesheet"
                                         ofType:@"xaml"]];

iXStylesheet *stylesheet = [[iXStylesheet alloc] initWithContentsOfURL:url];

[UIApplication sharedApplication].stylesheet = stylesheet;
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