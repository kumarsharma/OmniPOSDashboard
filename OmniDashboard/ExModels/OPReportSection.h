//
//  OPReportSection.h
//  OmniDashboard
//
//  Created by Kumar Sharma on 28/04/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPReportSection : NSObject
{
    
}
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, assign) OPReportType reportType;
@property (nonatomic, strong) NSString *sectionTitle;
@end
