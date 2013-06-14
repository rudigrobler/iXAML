#import "iXStyle.h"
#import "iXStylesheet.h"

@implementation iXStylesheet {
    NSXMLParser *parser;

    NSString *styleName;
    iXStyle *style;

    NSMutableDictionary *_proxy;
}

- (id)initWithContentsOfURL:(NSURL *)url {
    if (self = [super init]) {
        _proxy = [[NSMutableDictionary alloc] init];

        parser = [[NSXMLParser alloc] initWithContentsOfURL:url];

        [parser setDelegate:self];
        [parser parse];
    }

    return self;
}

- (id)init {
    if (self == [super init]) {
        _proxy = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"Style"]) {
        style = [[iXStyle alloc] init];
        styleName = [attributeDict valueForKey:@"name"];
    }
    else if ([elementName isEqualToString:@"Setter"]) {
        [style setValue:[attributeDict valueForKey:@"value"] forKey:[attributeDict valueForKey:@"property"]];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"Style"]) {
        [_proxy setValue:style forKey:styleName];

        style = nil;
        styleName = nil;
    }
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

@end
