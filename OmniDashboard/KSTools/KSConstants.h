//
//  KSConstants.h
//  LeaveRequest
//
//  Created by Kumar Sharma on 05/02/13.
//  Copyright (c) 2013 KSR. All rights reserved.
//

#ifndef LeaveRequest_KSConstants_h
#define LeaveRequest_KSConstants_h

#define SYSTEM_VERSION_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#import "Response.h"


typedef enum {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN,
	Reachable
} NetworkStatus;

typedef enum {
    
    KSObjectEditTypeNone = 0,
    KSObjectEditTypeText,
    KSObjectEditTypeDate,
    KSObjectEditTypeList,
    KSObjectEditTypeTable,
    KSObjectEditTypeDateTime
}KSObjectEditType;

typedef enum {
    
    OPAlignmentLeft = 1,
    OPAlignmentRight
    
}OPAlignment;


#define kSaleAdjustAlert 10
#define kRetryReportALert 20
#define kConfirmAdjustReportAlert 30
#define kDidAdjustSale 40
#define kConfirmDirectAdjustment 50
#define kEnterPercentageAlert 60

#define kRestaurantObject @"RestaurantObject"
#define kCompanyObject @"CompanyObject"
#define kLoginPIN @"LoginPIN"

#define kUserObject @"UserObject"


#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"
#define kDidFinishActiveNetworkOperations @"kDidFinishActiveNetworkOperations"
#define kDidFailActiveNetworkOperations @"kDidFailActiveNetworkOperations"

#define kCurrentSale @"Current Sale"
#define kSalesSummary @"Sales Summary"
#define kHourlySales @"Hourly Sales"
#define kItemSold @"Item Sold"
#define kStockReport @"Stock Report"
#define kUserAttendance @"User Attendance"

typedef enum{
    
    OPReportTypeCurrent = 1,
    OPReportTypeSaleSummary = 2,
    OPReportTypeHourlySale = 3,
    OPReportTypeItemSold  = 4,
    OPReportTypeCategorySold  = 5
    
}OPReportType;

typedef enum {
    
    OPReportsDetailTypeNone = 0,
    OPReportsDetailTypeSales,
    OPReportsDetailTypeDeviceSales,
    OPReportsDetailTypeDeletedItems,
    OPReportsDetailTypeUserSale,
    OPReportsDetailTypeUserShift,
    OPReportsDetailTypeClearReports,
    OPReportsDetailTypeZReport,
    OPReportsDetailTypeXReport,
    OPReportsDetailTypeZReportHistory,
    OPReportsDetailTypeStatements,
    OPReportsDetailTypeRefundItems,
    OPReportsDetailTypeSessionReportHistory,
    OPReportsDetailTypeHourlySales,
    OPReportsDetailTypeItemSold,
    OPReportsDetailTypeStockReport,
    OPReportsDetailTypeCurrentSales
}OPReportsDetailType;

#define kAppName @"OmniDashboard"
typedef void (^endRequestCompletionBlk_t)(BOOL success, Response *response);



#endif
