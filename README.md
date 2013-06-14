# iXAML

iXAML is a proof of concept to add VERY basic binding & styling support for iOS. The API design is based on XAML.

## Styling

Add the following stylesheet to your application

```xml
<Stylesheet>
    <Style name="textHeaderStyle">
        <Setter property="textColor" value="#00000" />
        <Setter property="font" value="SegoeUI-Bold" />
    </Style>
    <Style name="textBodyStyle">
        <Setter property="textColor" value="#888888" />
        <Setter property="font" value="SegoeUI-Light" />
    </Style>
    <Style name="pageStyle">
        <Setter property="backgroundColor" value="#F1F1F1" />
    </Style>
    <Style name="buttonStyle">
        <Setter property="backgroundColor" value="#000000" />
        <Setter property="textColor" value="#FFFFFF" />
        <Setter property="font" value="SegoeUI-Light" />
    </Style>
</Stylesheet>
```

![Interface Builder](https://github.com/rudigrobler/iXAML/blob/master/Documentation/SetStyleInIB.jpg)


* Open Interface Builder
* Click on the UIView (control) to apply the style too
* In the User Defined Runtime Attributes, add a new string called 'style'
* Set the style value to match the name of the style from the stylesheet

## Binding