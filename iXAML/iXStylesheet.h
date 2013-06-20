#import <Foundation/Foundation.h>

@interface iXStylesheet : NSMutableDictionary <NSXMLParserDelegate>

- (id)initWithXAML:(NSURL *)url;

@end
