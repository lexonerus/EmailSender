//
//  ViewController.h
//  InstaEmail
//
//  Created by Alexey Krzywicki on 29.07.2023.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

// MARK: - Public methods
@interface InstaEmailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, MFMailComposeViewControllerDelegate> {
    NSArray* activities_;
    NSArray* feelings_;
}

- (void)showAlert:(NSString *)messageText; 

@end

