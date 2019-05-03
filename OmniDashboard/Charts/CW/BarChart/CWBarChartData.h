//
//  CWBarChartData.h
//  ChartJSWrapper
//
//  Created by András Gyetván on 22/03/15.
//  Copyright (c) 2015 Gyetván András. All rights reserved.
//

#import "CWLabelledData.h"

@interface CWBarChartData : CWLabelledData
- (instancetype) initWithLabels:(NSArray*)labels andBarDataSet:(NSArray*)dataSet;

@end
