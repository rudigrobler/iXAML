#import "iXStyle.h"

@interface iXStyle ()

@property NSMutableDictionary *proxy;
@end

@implementation iXStyle

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

#pragma mark - Forwarding

- (BOOL)respondsToSelector:(SEL)aSelector
{
	if ( [super respondsToSelector:aSelector] )
		return YES;

	if ([self.proxy respondsToSelector:aSelector])
		return YES;

	return NO;
}

- (NSMethodSignature*) methodSignatureForSelector:(SEL)selector
{
	NSMethodSignature* signature = [super methodSignatureForSelector:selector];

	if (!signature)
		signature = [self.proxy methodSignatureForSelector:selector];

	return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	NSLog(@"forwardInvocation: %@ %@", NSStringFromClass([self class]), NSStringFromSelector([anInvocation selector]));

	if ([self.proxy respondsToSelector:[anInvocation selector]])
	{
		[anInvocation invokeWithTarget:_proxy];
	}
	else
	{
		[super forwardInvocation:anInvocation];
	}
}

- (id)forwardingTargetForSelector:(SEL)sel
{
	if ([self.proxy respondsToSelector:sel])
		return self.proxy;
	return nil;
}

@end
