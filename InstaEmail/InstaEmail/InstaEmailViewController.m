//
//  ViewController.m
//  InstaEmail
//
//  Created by Alexey Krzywicki on 29.07.2023.
//

#import "InstaEmailViewController.h"
#import <os/log.h>


// MARK: - Internal properties & methods
@interface InstaEmailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIPickerView *emailPicker;

@end

// MARK: - Realization
@implementation InstaEmailViewController {
    // Private properties
    os_log_t myLog; // Declare os_log_t at the class level
}

#pragma mark -
#pragma mark Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a log object with the specified subsystem identifier
    myLog = os_log_create("com.example.myapp", "DEBUG");
    
    activities_ = [[NSArray alloc] initWithObjects: @"sleeping", @"eating", @"working", @"thinking", @"crying", @"begging", @"leaving", @"shopping", @"hello wolding", nil];
    
    feelings_ = [[NSArray alloc] initWithObjects: @"awesome", @"sad", @"happy", @"ambivalent", @"nauseous", @"psyched", @"confused", @"hopeful", @"anxious", nil];

// Made this things in IB
//    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
//    pickerView.dataSource = self;
//    pickerView.delegate = self;
    
//     Add pickerView to your view hierarchy and set its constraints or frame
//     [self.view addSubview:pickerView];
}

// Not needed in ARC mode
//- (void)dealloc {
//    [activities_ release];
//    [feelings_ release];
//    [super dealloc];
//}

/*
 #pragma mark - is used in Objective-C to create sections,
 but it is recommended to use // MARK: - in Swift to take advantage
 of section navigation in Xcode. If you are working with
 Objective-C and Xcode version 9 and above, it is better to use
 // MARK: - instead of #pragma mark -.
*/

#pragma mark -
#pragma mark Actions

- (IBAction)sendButtonAction:(id)sender {
    NSString* theMessage = [NSString stringWithFormat: @"I'm %@ and feeling %@ about it.",
                            [activities_ objectAtIndex:[_emailPicker selectedRowInComponent: 0]],
                            [feelings_ objectAtIndex:[_emailPicker selectedRowInComponent: 1]]
                           ];
    os_log_info(myLog, "%@", _sendButton.titleLabel.text);
    os_log_info(myLog, "%@", theMessage);
    
    [self showAlert: theMessage];
}


#pragma mark -
#pragma mark Picker DataSource Protocol

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [activities_ count];
    } else {
        return [feelings_ count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return activities_[row];
    } else {
        return [feelings_ objectAtIndex: row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        // NSLog(@"Selected activity: %@", activities_[row]);
        // printf("Selected activity: %s\n", [activities_[row] UTF8String]);
        os_log_info(myLog, "Selected activity: %@", activities_[row]);
    } else {
        // NSLog(@"Selected feeling: %@", feelings_[row]);
        // printf("Selected feeling: %s\n", [feelings_[row] UTF8String]);
        os_log_info(myLog, "Selected activity: %@", feelings_[row]);
    }
}


#pragma mark -
#pragma mark Mail composer delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark Public methods
- (void)showAlert: messageText {
    {
        // Create UIAlertController with style UIAlertControllerStyleAlert
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message: messageText preferredStyle:UIAlertControllerStyleAlert];
        
        // Create "ОК" button with handler
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            os_log_info(self->myLog, "Ok button pressed");
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
                mailController.mailComposeDelegate = self;
                [mailController setSubject:@"Hello from Alex!"];
                [mailController setMessageBody: messageText isHTML:NO];
                // deprecated
                // [self presentModalViewController:mailController animated:YES];
                // Present the view controller modally
                [self presentViewController:mailController animated:YES completion:nil];
            } else {
                os_log_error(self->myLog, "%@", @"Sorry, you need to setUp mail first.");
            }
        }];
        
        // Add "ОК" button to alert
        [alertController addAction:okAction];
        
        // Show alert on screen
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
