
#import <UIKit/UIKit.h>

@protocol TTTopChannelContianerViewDelegate <NSObject>

@optional

- (void)showOrHiddenAddChannelsCollectionView:(UIButton *)button;
- (void)chooseChannelWithIndex:(NSInteger)index;

@end

@interface TTTopChannelContianerView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (void)addAChannelButtonWithChannelName:(NSString *)channelName;
- (void)selectChannelButtonWithIndex:(NSInteger)index;
- (void)deleteChannelButtonWithIndex:(NSInteger)index;
- (void)updateToDaySkinMode;
- (void)updateToNightSkinMode;
- (void)didShowEditChannelView:(BOOL)value;

@property (nonatomic, strong) NSArray *channelNameArray;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *addButton;
@property (nonatomic, weak) id<TTTopChannelContianerViewDelegate> delegate;

@end
