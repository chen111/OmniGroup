// Copyright 1997-2005, 2007-2008-2011 Omni Development, Inc.  All rights reserved.
//
// This software may only be used and reproduced according to the
// terms in the file OmniSourceLicense.html, which should be
// distributed with this project and can also be found at
// <http://www.omnigroup.com/developer/sourcecode/sourcelicense/>.

#import <OmniFoundation/OFIObjectSelectorObjectObjectObject.h>

#import <objc/objc-class.h>

RCS_ID("$Id$")

@implementation OFIObjectSelectorObjectObjectObject;

static Class myClass;

+ (void)initialize;
{
    OBINITIALIZE;
    myClass = self;
}

- initForObject:(id)targetObject selector:(SEL)aSelector withObject:(id)anObject1 withObject:(id)anObject2 withObject:(id)anObject3;
{
    OBPRECONDITION([targetObject respondsToSelector:aSelector]);

    if (!(self = [super initForObject:targetObject selector:aSelector]))
        return nil;

    object1 = [anObject1 retain];
    object2 = [anObject2 retain];
    object3 = [anObject3 retain];

    return self;
}

- (void)dealloc;
{
    [object1 release];
    [object2 release];
    [object3 release];
    [super dealloc];
}

- (void)invoke;
{
    Class cls = object_getClass(object);
    Method method = class_getInstanceMethod(cls, selector);
    if (!method)
        [NSException raise:NSInvalidArgumentException format:@"%s(%p) does not respond to the selector %@", class_getName(cls), object, NSStringFromSelector(selector)];

    method_getImplementation(method)(object, selector, object1, object2, object3);
}

- (NSUInteger)hash;
{
    uintptr_t hashv = (uintptr_t)object + (uintptr_t)(void *)selector + (uintptr_t)object1 + (uintptr_t)object2 + (uintptr_t)object3;
    return OFHashUIntptr(hashv);
}

- (BOOL)isEqual:(id)anObject;
{
    OFIObjectSelectorObjectObjectObject *otherObject;

    otherObject = anObject;
    if (object_getClass(otherObject) != myClass)
        return NO;
    return object == otherObject->object && selector == otherObject->selector && object1 == otherObject->object1 && object2 == otherObject->object2 && object3 == otherObject->object3;
}

- (NSMutableDictionary *)debugDictionary;
{
    NSMutableDictionary *debugDictionary;

    debugDictionary = [super debugDictionary];
    if (object)
        [debugDictionary setObject:object forKey:@"object"];
    [debugDictionary setObject:NSStringFromSelector(selector) forKey:@"selector"];
    if (object1)
        [debugDictionary setObject:object1 forKey:@"object1"];
    if (object2)
        [debugDictionary setObject:object2 forKey:@"object2"];
    if (object3)
        [debugDictionary setObject:object3 forKey:@"object3"];

    return debugDictionary;
}

- (NSString *)shortDescription;
{
    return [NSString stringWithFormat:@"-[%@ %@(%@,%@,%@)]", OBShortObjectDescription(object), NSStringFromSelector(selector), OBShortObjectDescription(object1), OBShortObjectDescription(object2), OBShortObjectDescription(object3)];
}

@end
