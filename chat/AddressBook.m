//
//  AddressBook.m
//  chat
//
//  Created by brightvision on 14-5-14.
//
//

#import "AddressBook.h"

@implementation AddressBook
@synthesize phoneList;

-(NSDictionary *)readAdressBook {
    phoneList = [NSMutableDictionary dictionaryWithCapacity:5];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        //读取firstname
        NSString *personName = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        //读取middlename
        NSString *middlename = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
        if(middlename != nil)
            personName = [personName stringByAppendingFormat:@"%@",middlename];
        //读取lastname
        NSString *lastname = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        if(lastname != nil)
            personName = [personName stringByAppendingFormat:@"%@",lastname];
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            //NSString * personPhoneLabel = (NSString*)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k)));
            //获取該Label下的电话值
            NSString * personPhone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, k));
            NSArray  *keys = [NSArray arrayWithObjects:PHONENUM, PHONENAME, FRIENDTYPE, nil];
            NSArray *objects = [NSArray arrayWithObjects:personPhone, personName, -1, nil];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
            [phoneList setObject:dictionary forKey:personPhone];
            
        }
        
        
    }
    
    CFRelease(results);
    CFRelease(addressBook);
    return phoneList;
    
}



@end
