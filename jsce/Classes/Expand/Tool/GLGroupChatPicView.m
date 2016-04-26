//
//  MultiImageView.m
//  GLGroupChatPicView
//
//  Created by Gautam Lodhiya on 30/04/14.
//  Copyright (c) 2014 Gautam Lodhiya. All rights reserved.
//

#import "GLGroupChatPicView.h"

@interface GLGroupChatPicView()
@property (nonatomic, assign) NSUInteger totalCount;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *layerArr;
@property (nonatomic, strong) CALayer *imageLayer1;
@property (nonatomic, strong) CALayer *imageLayer2;
@property (nonatomic, strong) CALayer *imageLayer3;
@property (nonatomic, strong) CALayer *imageLayer4;
@property (nonatomic, strong) CALayer *imageLayer5;
@property (nonatomic, strong) CALayer *imageLayer6;
@property (nonatomic, strong) CALayer *imageLayer7;
@property (nonatomic, strong) CALayer *imageLayer8;
@property (nonatomic, strong) CALayer *imageLayer9;

@property (nonatomic, strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *shadowColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGSize shadowOffset UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat shadowBlur UI_APPEARANCE_SELECTOR;
@end

@implementation GLGroupChatPicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}


#pragma mark -
#pragma mark - Public helpers

- (void)addImage:(UIImage *)image withInitials:(NSString *)initials
{
   
    self.totalCount++;
    if (initials.length>0) {
        NSString *firstLetter = [[initials substringToIndex:1] capitalizedString];
        [self addInitials:firstLetter];
    }else{
        [self.images addObject:image];
    }
 
}

- (void)addImageURL:(NSString *)imageURL withInitials:(NSString *)initials
{
    
}

- (void)addInitials:(NSString *)initials
{
    if (initials && initials.length) {
        CGFloat width = 0;
        CGSize size = self.frame.size;
        
        if (self.totalCount == 0) {
            width = floorf(size.width);
        } else if (self.totalCount == 1) {
            width = floorf(size.width * 0.7);
        } else if (self.totalCount == 2) {
            width = floorf(size.width * 0.4);
        } else if (self.totalCount > 2) {
            width = floorf(size.width * 0.5);
        }
        
        CGFloat fontSize = initials.length == 1 ? width * 0.6 : width * 0.5;
        UIImage *image = [self imageFromText:initials withCanvasSize:CGSizeMake(width, width) andFontSize:fontSize];
        if (image) {
            [self.images addObject:image];
        }
    }
}

- (void)reset
{
    self.totalEntries = 0;
    self.totalCount = 0;
    [self.images removeAllObjects];
    [self resetLayers];
}

- (void)updateLayout
{
    [self resetLayers];
    
    if (self.images) {
        CGFloat width = 0;
        CGSize size = self.frame.size;
        
        if (self.images.count == 1) {
            width = floorf(size.width)/2;
            
            self.imageLayer1.contents = (id)((UIImage *)self.images[0]).CGImage;
            self.imageLayer1.frame = CGRectMake((size.width-width)/2.0, (size.width-width)/2.0, width, width);
           
            self.imageLayer1.hidden = NO;
            
        } else if (self.images.count == 2) {
            CGFloat temp = (size.width-3*3)/2.0;
            width = temp;
            
            for (int i =0; i<self.images.count; i++) {
                CALayer *layer = self.layerArr[i];
                layer.contents =(id)((UIImage *)self.images[i]).CGImage;
                layer.zPosition = 0;
                layer.hidden = NO;
                int x = 3*(i+1)+i*width;
                int y = (size.height - width)/2.0;
                layer.frame = CGRectMake(x, y, width, width);
            }
            
        } else if (self.images.count == 3) {
            
            CGFloat temp = (size.width-3*3)/2.0;
            width = temp;
            for (int i =0; i<self.images.count; i++) {
                CALayer *layer = self.layerArr[i];
                layer.contents =(id)((UIImage *)self.images[i]).CGImage;
                layer.zPosition = 0;
                layer.hidden = NO;
                
                if (i==0) {
                    layer.frame = CGRectMake((size.width-width)/2.0, 3, width, width);
                    
                }else{
                    int x = 3*i+(i-1)*width;
                    int y = size.height - width-3;
                    layer.frame = CGRectMake(x, y, width, width);
                }
                
       
            }
            
            
        } else if (self.images.count == 4) {
            CGFloat temp = (size.width-3*3)/2.0;
            width = temp;
            for (int i =0; i<self.images.count; i++) {
                CALayer *layer = self.layerArr[i];
                layer.contents =(id)((UIImage *)self.images[i]).CGImage;
                layer.zPosition = 0;
                layer.hidden = NO;
                
                int row=i/2;
                int col = i%2;
                
                int x = 3*(col+1)+col*width;
                int y = 3*(row+1)+row*width;
                layer.frame = CGRectMake(x, y, width, width);
                
     
            }
            
        }else if(self.images.count == 5){
            
            CGFloat temp = (size.width-4*3)/3.0;
            width = temp;
            for (int i =0; i<self.images.count; i++) {
                CALayer *layer = self.layerArr[i];
                layer.contents =(id)((UIImage *)self.images[i]).CGImage;
                layer.zPosition = 0;
                layer.hidden = NO;
                
                CGFloat topHeight=(size.height-2*width-3)/2.0;
                
                if (i==0||i==1) {
                    int x =topHeight+3*i+i*width;
                    layer.frame=CGRectMake(x, topHeight, width, width);
                }else{
    
                    int x = 3*(i-1)+(i-2)*width;
                    int y = topHeight+width+3;
                    layer.frame = CGRectMake(x, y, width, width);
                    
                }

            }

        }else if(self.images.count == 6){
            
            CGFloat temp = (size.width-4*3)/3.0;
            width = temp;
            for (int i =0; i<self.images.count; i++) {
                CALayer *layer = self.layerArr[i];
                layer.contents =(id)((UIImage *)self.images[i]).CGImage;
                layer.zPosition = 0;
                layer.hidden = NO;
                
                CGFloat topHeight=(size.height-2*width-3)/2.0;
                
                int row=i/3;
                int col = i%3;
                
                int x = 3*(col+1)+col*width;
                int y = topHeight+3*row+row*width;
                layer.frame = CGRectMake(x, y, width, width);
                
            }
            
            
        }else if(self.images.count == 7){
            CGFloat temp = (size.width-4*3)/3.0;
            width = temp;
            for (int i =0; i<self.images.count; i++) {
                CALayer *layer = self.layerArr[i];
                layer.contents =(id)((UIImage *)self.images[i]).CGImage;
                layer.zPosition = 0;
                layer.hidden = NO;
                
                if (i==0) {
                    layer.frame = CGRectMake((size.width-temp)/2.0, 3, width, width);
                }else{
                    
                    int row=(i-1)/3;
                    int col = (i-1)%3;
                    
                    int x = 3*(col+1)+col*width;
                    int y = 3*(row+2)+(row+1)*width;
                    layer.frame = CGRectMake(x, y, width, width);
                    
                }
                
                
            }
   
        }else if(self.images.count == 8){
            
            CGFloat temp = (size.width-4*3)/3.0;
            width = temp;
            for (int i =0; i<self.images.count; i++) {
                CALayer *layer = self.layerArr[i];
                layer.contents =(id)((UIImage *)self.images[i]).CGImage;
                layer.zPosition = 0;
                layer.hidden = NO;
                
                if (i==0||i==1) {
                    CGFloat padding=(size.width-width)/3.0;
                    layer.frame = CGRectMake(padding+(3+width)*i, 3, width, width);
                }else{
                    
                    int row=(i-2)/3;
                    int col = (i-2)%3;
                    
                    int x = 3*(col+1)+col*width;
                    int y = 3*(row+2)+(row+1)*width;
                    layer.frame = CGRectMake(x, y, width, width);
                    
                }
                
                
            }
            
        }else if(self.images.count >= 9){
            CGFloat temp = (size.width-4*3)/3.0;
            width = temp;
            for (int i =0; i<9; i++) {
                CALayer *layer = self.layerArr[i];
                layer.contents =(id)((UIImage *)self.images[i]).CGImage;
                layer.zPosition = 0;
                layer.hidden = NO;

                int row=i/3;
                int col =i%3;
                
                int x = 3*(col+1)+col*width;
                int y = 3*(row+1)+row*width;
                layer.frame = CGRectMake(x, y, width, width);
                
            }
        }
    }
}


#pragma mark -
#pragma mark - Private helpers

- (void)setup
{
    self.backgroundColor = RGB(222, 222, 222);
    self.layer.cornerRadius=5;
    self.borderColor = [UIColor whiteColor];
    self.borderWidth = 1.f;
    self.shadowColor = [UIColor colorWithRed:0.25f green:0.25f blue:0.25f alpha:.75f];
    self.shadowOffset = CGSizeMake(0, 0);
    self.shadowBlur = 2.f;
    
    self.images = [@[] mutableCopy];
    
    self.layerArr =[@[self.imageLayer1,self.imageLayer2,self.imageLayer3,self.imageLayer4,self.imageLayer5,self.imageLayer6,self.imageLayer7,self.imageLayer8,self.imageLayer9] mutableCopy];
}

- (void)resetLayers
{
    self.imageLayer1.hidden = YES;
    self.imageLayer2.hidden = YES;
    self.imageLayer3.hidden = YES;
    self.imageLayer4.hidden = YES;
    self.imageLayer5.hidden = YES;
    self.imageLayer6.hidden = YES;
    self.imageLayer7.hidden = YES;
    self.imageLayer8.hidden = YES;
    self.imageLayer9.hidden = YES;
    
    self.imageLayer1.zPosition = 0;
    self.imageLayer2.zPosition = 0;
    self.imageLayer3.zPosition = 0;
    self.imageLayer4.zPosition = 0;
    self.imageLayer5.zPosition = 0;
    self.imageLayer6.zPosition = 0;
    self.imageLayer7.zPosition = 0;
    self.imageLayer8.zPosition = 0;
     self.imageLayer9.zPosition = 0;
}

- (CALayer *)getImageLayer
{
    CALayer *mImageLayer = [CALayer layer];

    return mImageLayer;
}

- (UIImage *)imageFromText:(NSString *)text withCanvasSize:(CGSize)canvasSize andFontSize:(CGFloat)fontSize
{
 //   if (UIGraphicsBeginImageContextWithOptions) {
        CGFloat imageScale = 0.0f;
        UIGraphicsBeginImageContextWithOptions(canvasSize, NO, imageScale);
//    }
//    else {
//        UIGraphicsBeginImageContext(self.frame.size);
//    }
//    
    
    UIColor *color = [self randomColor];
    //UIColor *color = [UIColor colorWithRed:203 green:205 blue:207 alpha:1];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGRect rect = CGRectMake(0.0f, 0.0f, canvasSize.width, canvasSize.height);
    CGContextFillRect(context, rect);
    
    
    // draw in context, you can use also drawInRect:withFont:
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];//[UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:fontSize];
    NSDictionary *attributesNew = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]};
    CGSize textSize = [text sizeWithAttributes:attributesNew];
    [text drawAtPoint:CGPointMake((canvasSize.width - textSize.width) / 2, (canvasSize.height - textSize.height) / 2) withAttributes:attributesNew];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


#pragma mark -
#pragma mark - Accessors

- (CALayer *)imageLayer1
{
    if (!_imageLayer1) {
        _imageLayer1 = [self getImageLayer];
        _imageLayer1.hidden = YES;
        [self.layer addSublayer:_imageLayer1];
    }
    return _imageLayer1;
}

- (CALayer *)imageLayer2
{
    if (!_imageLayer2) {
        _imageLayer2 = [self getImageLayer];
        _imageLayer2.hidden = YES;
        [self.layer addSublayer:_imageLayer2];
    }
    return _imageLayer2;
}

- (CALayer *)imageLayer3
{
    if (!_imageLayer3) {
        _imageLayer3 = [self getImageLayer];
        _imageLayer3.hidden = YES;
        [self.layer addSublayer:_imageLayer3];
    }
    return _imageLayer3;
}

- (CALayer *)imageLayer4
{
    if (!_imageLayer4) {
        _imageLayer4 = [self getImageLayer];
        _imageLayer4.hidden = YES;
        [self.layer addSublayer:_imageLayer4];
    }
    return _imageLayer4;
}
- (CALayer *)imageLayer5
{
    if (!_imageLayer5) {
        _imageLayer5 = [self getImageLayer];
        _imageLayer5.hidden = YES;
        [self.layer addSublayer:_imageLayer5];
    }
    return _imageLayer5;
}

- (CALayer *)imageLayer6
{
    if (!_imageLayer6) {
        _imageLayer6 = [self getImageLayer];
        _imageLayer6.hidden = YES;
        [self.layer addSublayer:_imageLayer6];
    }
    return _imageLayer6;
}

- (CALayer *)imageLayer7
{
    if (!_imageLayer7) {
        _imageLayer7 = [self getImageLayer];
        _imageLayer7.hidden = YES;
        [self.layer addSublayer:_imageLayer7];
    }
    return _imageLayer7;
}

- (CALayer *)imageLayer8
{
    if (!_imageLayer8) {
        _imageLayer8 = [self getImageLayer];
        _imageLayer8.hidden = YES;
        [self.layer addSublayer:_imageLayer8];
    }
    return _imageLayer8;
}

- (CALayer *)imageLayer9
{
    if (!_imageLayer9) {
        _imageLayer9 = [self getImageLayer];
        _imageLayer9.hidden = YES;
        [self.layer addSublayer:_imageLayer9];
    }
    return _imageLayer9;
}

@end
