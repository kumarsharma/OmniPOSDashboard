//
//  OPReportHolder.h
//  omniPOS
//
//  Created by Kumar Sharma on 11/04/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPReportHolder : NSObject
{
    NSString *fromDate, *tillDate;
    float cashSale, cardSale, voucherSale, refundAmount, payoutAmount, tipAmount, taxAmount, surChargeAmount, discountAmount, totalNetAmount, grossAmount, paypalSale, creditSale, loyaltyPointsSale, onlineSale, mixSale, taSale, diSale;
    int totalTiTrans, totalDITrans, totalQty;
    float pendingCashSale, pendingCardSale, pendingVoucherSale, pendingOtherSale, pendingTax, pendingGrossSale, pendingNetSale, pendingDiscount, pendingSurcharge;
    
    NSMutableArray *drawerDetails, *employeeDetails, *categoryDetails, *productDetails, *modifierDetails, *deviceDetails;
    
}

@property (nonatomic, strong) NSString *fromDate, *tillDate, *reportTitle;
@property (nonatomic, assign) float cashSale, cardSale, voucherSale, refundAmount, payoutAmount, tipAmount, taxAmount, surChargeAmount, discountAmount, totalNetAmount, grossAmount, paypalSale, creditSale, loyaltyPointsSale, onlineSale, mixSale, taSale, diSale, pendingCashSale, pendingCardSale, pendingVoucherSale, pendingOtherSale, pendingTax, pendingGrossSale, pendingNetSale, pendingDiscount, pendingSurcharge;

@property (nonatomic, strong) NSMutableArray *drawerDetails, *employeeDetails, *categoryDetails, *productDetails, *modifierDetails, *deviceDetails;
@property (nonatomic, assign) int totalTiTrans, totalDITrans, totalQty;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, strong) NSDictionary *hourlySales, *itemSolds;
@property (nonatomic, assign) OPReportType reportType;

+ (OPReportHolder *)parseXml:(NSData *)xmlData;
@end
