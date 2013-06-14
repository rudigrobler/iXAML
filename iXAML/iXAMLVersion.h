#import <Foundation/Foundation.h>

/**
 * Expressed in MAJOR.MINOR.BUGFIX(.HOTFIX) notation.
 *
 * For example, 1.0.5.1 is:
 *  - the first major release,
 *  - with no minor updates,
 *  - with 5 bugfix patches,
 *  - and 1 hotfix patch.
 *
 * The .HOTFIX version will only be present if hotfixVersion is > 0.
 */
extern NSString* const iXAMLVersion;
