#import <UIKit/UIKit.h>
#import "JSON.h"

@interface ChannelsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *developer;
@property (weak, nonatomic) IBOutlet UILabel *insight;
@property (weak, nonatomic) IBOutlet UILabel *streamurl;
@end
