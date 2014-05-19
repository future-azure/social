//
//  AddressBook.h
//  chat
//
//  Created by brightvision on 14-5-14.
//
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#define PHONENAME @"phoneName"
#define PHONENUM @"phoneNum"
#define FRIENDTYPE @"friendType"

@interface AddressBook : NSObject {
    
}
@property (nonatomic, strong) NSMutableDictionary *phoneList;

+ (AddressBook *)initAddressBook;
-(NSMutableDictionary *)readAdressBook;

@end
