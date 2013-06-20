#import "iXStyle.h"

@interface iXStyle ()

@property NSMutableDictionary *proxy;
@end

@implementation iXStyle

- (id)init {
    if (self = [super init]) {
        self.proxy = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)setObject:(id)obj forKey:(id)key {
    if (obj) {
        [self.proxy setObject:obj forKey:key];
    } else {
        [self.proxy removeObjectForKey:key];
    }
}

- (id)objectForKey:(id)aKey {
    return [self.proxy objectForKey:aKey];
}

- (NSUInteger)count {
    return self.proxy.count;
}

- (NSEnumerator *)keyEnumerator {
    return self.proxy.keyEnumerator;
}

@end
