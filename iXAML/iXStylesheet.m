#import "iXStyle.h"
#import "iXStylesheet.h"

@interface iXStylesheet ()

@property NSMutableDictionary *proxy;

@end

@implementation iXStylesheet {
    NSMutableDictionary *_currentElement;
    NSXMLParser *_parser;
}

- (id) init
{
    if (self = [super init])
    {
        self.proxy = [[NSMutableDictionary alloc] init];
    }

    return self;
}


- (void) setObject:(id)obj forKey:(id)key
{
    if (obj)
    {
        [self.proxy setObject:obj forKey:key];
    }
    else
    {
        [self.proxy removeObjectForKey:key];
    }
}


- (id) objectForKey:(id)aKey
{
    return [self.proxy objectForKey:aKey];
}


- (NSUInteger) count
{
    return self.proxy.count;
}


- (NSEnumerator *) keyEnumerator
{
    return self.proxy.keyEnumerator;
}


#pragma mark - XAML

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"Style"])
    {
        _currentElement = [[NSMutableDictionary alloc] init];
        [_currentElement setValue:[attributeDict valueForKey:@"name"] forKey:@"style-name"];
    }
    else if ([elementName isEqualToString:@"Setter"])
    {
        NSString *property = [attributeDict valueForKey:@"property"];
        NSString *state = [attributeDict valueForKey:@"state"];
        if (state)
        {
            property = [NSString stringWithFormat:@"%@[%@]", property, state];
        }

        [_currentElement setValue:[attributeDict valueForKey:@"value"] forKey:property];
    }
}


- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Style"])
    {
        NSString *styleName = [_currentElement valueForKey:@"style-name"];
        iXStyle *style = [[iXStyle alloc] init];

        for (NSString *key in [_currentElement keyEnumerator])
        {
            [style setValue:[_currentElement valueForKey:key] forKey:key];
        }

        [_proxy setValue:style forKey:styleName];
        _currentElement = nil;
    }
    else if ([elementName isEqualToString:@"Stylesheet"])
    {
    }
}


- (id) initWithXAML:(NSURL *)url
{
    if (self = [super init])
    {
        _proxy = [[NSMutableDictionary alloc] init];
        _parser = [[NSXMLParser alloc] initWithContentsOfURL:url];

        [_parser setDelegate:self];
        [_parser parse];
    }

    return self;
}


@end
