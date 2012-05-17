
#import <UIKit/UIKit.h>

@class WaterFlowView;

////TableCell for WaterFlow
@interface WaterFlowCell:UIView
{
    NSIndexPath *_indexPath;
    NSString *_reuseIdentifier;
}

@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) NSString *reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end

////DataSource and Delegate
@protocol WaterFlowViewDatasource <NSObject>
@required
- (NSInteger)numberOfColumnsInFlowView:(WaterFlowView*)flowView;
- (NSInteger)flowView:(WaterFlowView *)flowView numberOfRowsInColumn:(NSInteger)column;
- (WaterFlowCell *)flowView:(WaterFlowView *)flowView cellForRowAtIndex:(NSInteger)index;

@end

@protocol WaterFlowViewDelegate <NSObject>
@required
- (CGFloat)flowView:(WaterFlowView *)flowView heightForCellAtIndex:(NSInteger)index;
@optional
- (void)flowView:(WaterFlowView *)flowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)flowView:(WaterFlowView *)flowView didSelectAtCell:(WaterFlowCell*)cell ForIndex:(int)index;
- (void)flowView:(WaterFlowView *)flowView willLoadData:(int)page;
@end

////Waterflow View
@interface WaterFlowView : UIScrollView<UIScrollViewDelegate>

- (void)reloadData;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@property (nonatomic, assign) id <WaterFlowViewDelegate> flowdelegate;
@property (nonatomic, assign) id <WaterFlowViewDatasource> flowdatasource;

@end
