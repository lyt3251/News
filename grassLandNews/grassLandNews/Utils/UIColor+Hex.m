//  Created by Jason Morrissey

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor*) colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16)) / 255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8)) / 255.0;
    float blue = ((float)(hexColor & 0xFF)) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

+ (UIColor *)colorWithHexStr:(NSString *)colorStr {
    NSString *redStr = [colorStr substringWithRange:NSMakeRange(0, 2)];
    NSScanner *redScanner = [NSScanner scannerWithString:redStr];
    unsigned int redIntValue;
    [redScanner scanHexInt:&redIntValue];
    
    NSString *greenStr = [colorStr substringWithRange:NSMakeRange(2, 2)];
    NSScanner *greenScanner = [NSScanner scannerWithString:greenStr];
    unsigned int greenIntValue;
    [greenScanner scanHexInt:&greenIntValue];
    
    NSString *blueStr = [colorStr substringWithRange:NSMakeRange(4, 2)];
    NSScanner *blueScanner = [NSScanner scannerWithString:blueStr];
    unsigned int blueIntValue;
    [blueScanner scanHexInt:&blueIntValue];
    
    return [UIColor colorWithRed:redIntValue / 255.0 green:greenIntValue / 255.0 blue:blueIntValue / 255.0 alpha:1];
}

@end
