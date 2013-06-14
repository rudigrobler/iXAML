#import "iXStyle.h"

@implementation iXStyle {
    NSMutableDictionary *_proxy;
}

- (id)init {
    if (self = [super init]) {
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

@end
