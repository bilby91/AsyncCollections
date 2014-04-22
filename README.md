# AsyncCollections

[![Version](http://cocoapod-badges.herokuapp.com/v/AsyncCollections/badge.png)](http://cocoadocs.org/docsets/AsyncCollections)
[![Platform](http://cocoapod-badges.herokuapp.com/p/AsyncCollections/badge.png)](http://cocoadocs.org/docsets/AsyncCollections)

**AsyncCollections** helps you out rendering a bitmap with CoreGraphics for your collection/table view cells in the background.

The approach we use here is shown in one of Apple's WWDC. I thought it would be helpful to encapsulate this code a reuse it.

## Usage

First of all we need to know which components interact during the process of drawing and displaying a cell. 

If you want to display a `UITableView` you need to subclass `LVAsyncTableViewController`, on the other hand if you are using a `UICollectionView`, subclass `LVAsyncCollectionViewController`. This controllers will be the delegate and datasource for the `UITableView` or `UICollectionView`. 

In AsyncCollections you don't use custom cells, we provide you one that has a UIImageView, this is the place we are going to insert your background render image. You need to implement `@protocol LVAsyncRender` in your desired view. This small protocol is used to ask the view to render itself and also to know if it has already been rendered.

In `- (UIImage *)renderWithSize:(CGSize)size;` is where you should put your CoreGraphics code, for example: 

    - (UIImage *)renderWithSize:(CGSize)size
    {
        if (_render != nil)
            return _render;
        
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
        
        CGRect middleRect = CGRectMake(size.width / 2, size.height / 3, 20, 20);

        [[UIColor redColor] setFill];
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
        
        _render = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return _render;
    }


The last thing we need to do is setup `LVAsyncTableViewControllerDelegate` or `LVAsyncCollectionViewControllerDelegate`. This `@protocol` will provide the necessary information for displaying the renders. Checkout `LVRedSquaresViewController` and `LVBlueSquaresViewController` in the example project to understand better how it works.

For this example we will assume your trying to display a UICollectionView.


`- (NSString *)asyncCollectionController:(LVAsyncCollectionViewController *)asyncCollectionController idForItemAtIndexPath:(NSIndexPath *)indexPath`. You need to provide an identifier for every item in your data source. This is going to be use internally for caching purpose. 

The other important delegate call is this one:

    -(void)asyncCollectionController:(LVAsyncCollectionViewController *)asyncCollectionController prepareRenderForItemAtIndexPath:(NSIndexPath *)indexPath withCompletion:(void (^)(id<LVAsyncRender>))completion
    {
        LVBlueSquareView *bView = [[LVBlueSquareView alloc] init];
        completion(bView);
    }

In this case `LVBlueSquareView` is a UIView that implements `LVAsyncRender`. We use a completion block instead of simply returning the view in case you need to process something asynchronously (like fetching an image) before being ready to render the view. 

If you implement cellForItem or cellForRow you need to call super to retrieve the appropriate cell, don't use dequeue methods. 

## Internals

`LVAsyncTableViewController` and `LVAsyncCollectionViewController` own a NSOperationQueue where the drawing code is executed. 

Previous renders are cached and drawing operations are cancelled if cell is not currently shown in the screen.

## Example

To run the example project; clone the repo, and run `pod install` from the Example directory first.

## Installation


AsyncCollections is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "AsyncCollections"

## Author

Martin F, me@bilby91.com

## License

AsyncCollections is available under the MIT license. See the LICENSE file for more info.

