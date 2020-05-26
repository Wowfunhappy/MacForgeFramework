/**
 * Copyright 2003-2009, Mike Solomon <mas63@cornell.edu>
 * SIMBL is released under the GNU General Public License v2.
 * http://www.opensource.org/licenses/gpl-2.0.php
 */

#import "SIMBLPlugin.h"

@implementation SIMBLPlugin

+ (SIMBLPlugin*) bundleWithPath:(NSString*)path
{
    return [[SIMBLPlugin alloc] initWithPath:path];
}

- (NSString*) path
{
    return path;
}

- (void) setPath:(NSString*)_path
{
    if (_path)
        path = [_path copy];
    else
        path = _path;
}

- (NSDictionary*) info
{
    return info;
}

- (void) setInfo:(NSDictionary*)_info
{
    if (info == _info)
        return;
    
    info = _info;
}

- (SIMBLPlugin*) initWithPath:(NSString*)_path
{
    if (!(self = [super init]))
        return nil;
    [self setPath:_path];
    
    NSArray* bundlePathParts = [NSArray arrayWithObjects:_path, @"Contents", @"Info.plist", nil];
    if (nil == bundlePathParts)
        return nil;
    NSString* bundlePath = [NSString pathWithComponents:bundlePathParts];
    if (nil == bundlePath) {
        NSLog(@"Unable to create bundle path string from components: %@", bundlePathParts);
        return nil;
    }
    NSDictionary* bundleDict = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
    if (nil == bundleDict) {
        NSLog(@"Unable to create dictionary from bundle at path '%@'", bundlePath);
        return nil;
    }
    if (0 == [bundleDict count]) {
        NSLog(@"Warning: Empty dictionary created from bundle at path '%@'", bundlePath);
        return nil;
    }
    
    [self setInfo:bundleDict];
    return self;
    
}

- (NSString*) bundleIdentifier
{
    return [info objectForKey:@"CFBundleIdentifier"];
}

- (id) objectForInfoDictionaryKey:(NSString*)key
{
    return [info objectForKey:key];
}

- (NSString*) _dt_info
{
    return [self objectForInfoDictionaryKey: @"CFBundleGetInfoString"];
}

- (NSString*) _dt_version
{
    return [self objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

- (NSString*) _dt_bundleVersion
{
    return [self objectForInfoDictionaryKey: @"CFBundleVersion"];
}

- (NSString*) _dt_name
{
    NSString* name = [self objectForInfoDictionaryKey:@"CFBundleName"];
    if (name != nil)
        return name;
    else
        return [[self path] lastPathComponent];
}

- (void) dealloc
{
//    if (path)
//        [path release];
//    if (info)
//        [info release];
//    [super dealloc];
}

@end

@implementation NSBundle (SIMBLCocoaExtensions)

- (NSString*) _dt_info
{
    return [self objectForInfoDictionaryKey: @"CFBundleGetInfoString"];
}

- (NSString*) _dt_version
{
    return [self objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

- (NSString*) _dt_bundleVersion
{
    return [self objectForInfoDictionaryKey: @"CFBundleVersion"];
}

- (NSString*) _dt_name
{
    return [self objectForInfoDictionaryKey:@"CFBundleName"];
}

@end

