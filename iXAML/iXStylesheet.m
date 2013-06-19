#import "iXStyle.h"
#import "iXStylesheet.h"

@implementation iXStylesheet {
    NSMutableDictionary *_currentElement;
    NSXMLParser *_parser;
    
    NSMutableDictionary *_proxy;
}

- (id)init {
    if (self == [super init]) {
        _proxy = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setObject:(id)obj forKey:(id)key {
    if (obj) {
        [_proxy setObject:obj forKey:key];
    } else {
        [_proxy removeObjectForKey:key];
    }
}

- (id)objectForKey:(id)aKey {
    return [_proxy objectForKey:aKey];
}

- (NSUInteger)count {
    return _proxy.count;
}

- (NSEnumerator *)keyEnumerator {

    return _proxy.keyEnumerator;
}

#pragma mark - XAML

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"Style"]) {
        _currentElement = [[NSMutableDictionary alloc] init];
        [_currentElement setValue:[attributeDict valueForKey:@"name"] forKey:@"style-name"];
    }
    else if ([elementName isEqualToString:@"Setter"]) {
        [_currentElement setValue:[attributeDict valueForKey:@"value"] forKey:[attributeDict valueForKey:@"property"]];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"Style"]) {
        NSString *styleName = [_currentElement valueForKey:@"style-name"];
        iXStyle *style = [[iXStyle alloc] init];
        
        for (NSString *key in [_currentElement keyEnumerator]) {
            [style setValue:[_currentElement valueForKey:key] forKey:key];
        }
        
        [_proxy setValue:style forKey:styleName];
        _currentElement = nil;
    }
    else if ([elementName isEqualToString:@"Stylesheet"])
    {
    }
}

- (id)initWithXAML:(NSURL *)url {
    if (self = [super init]) {
        _proxy = [[NSMutableDictionary alloc] init];
        _parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        [_parser setDelegate:self];
        [_parser parse];
    }
    
    return self;
}

@end
