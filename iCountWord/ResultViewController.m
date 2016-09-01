//
//  ResultViewController.m
//  iCountWord
//
//  Created by Bui Duc Khanh on 9/1/16.
//  Copyright © 2016 Bui Duc Khanh. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController
{
    UIScrollView * scrollView;

    NSArray * separator;
    
    NSArray * unwantedWords;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Kết quả";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Các ký tự dấu và từ viết tắt để ở đây
    separator = @[@"\n", @"\t", @"\"", @".", @",", @";", @":", @"!", @"'s", @"'re", @"'ve", @"'ll", @"'"];
    
    // Các ký tự tầm thường
    unwantedWords = @[@"i", @"it", @"you", @"he", @"she", @"they", @"we", @"am", @"is", @"are", @"be", @"been", @"was", @"were", @"have", @"has", @"had", @"will", @"would", @"a", @"an", @"the", @"this", @"that", @"here", @"there", @"those", @"for", @"to", @"in", @"on", @"of", @"by", @"as", @"so", @"not", @"all", @"and", @"but", @"his", @"her"];
    
    
    // Tạo cái scroll view đề phòng dữ liệu dài
    scrollView = [UIScrollView new];
    
    [self.view addSubview:scrollView];
    
    
    // Set top, right, bottom, left = 0
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *topScrolllConstraint = [NSLayoutConstraint constraintWithItem:scrollView
                                                                            attribute:NSLayoutAttributeTop
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.view
                                                                            attribute:NSLayoutAttributeTop
                                                                           multiplier:1.0f
                                                                             constant:0];
    
    NSLayoutConstraint *rightScrolllConstraint = [NSLayoutConstraint constraintWithItem:scrollView
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0f
                                                                               constant:0];
    
    NSLayoutConstraint *bottomScrolllConstraint = [NSLayoutConstraint constraintWithItem:scrollView
                                                                               attribute:NSLayoutAttributeBottom
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.view
                                                                               attribute:NSLayoutAttributeBottom
                                                                              multiplier:1.0f
                                                                                constant:0];
    
    NSLayoutConstraint *leftScrolllConstraint = [NSLayoutConstraint constraintWithItem:scrollView
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.0f
                                                                              constant:0];
    
    [self.view addConstraints:@[topScrolllConstraint, rightScrolllConstraint, bottomScrolllConstraint, leftScrolllConstraint]];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Xoá giao diện
    [scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
}


// Hiển thị kết quả đếm từ
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    float y = 0;
    float w = self.view.frame.size.width;
    float h = 25;
    int columns = 2;
    
    // Gọi hàm lấy kết quả đếm
    NSMutableDictionary * result = [self countWord];
    
    // Sắp xếp lại từ a -> z cho dễ nhìn và kiểm tra
    NSArray *keys = [self quickSortString:[result.allKeys mutableCopy]];
    
    for (int i = 0; i < keys.count; i++)
    {
        if (i%columns == 0 && i > 0)
            y = y + h;
        
        
        UILabel *lbl = [UILabel new];
        lbl.frame = CGRectMake( (i % columns) * (w / ((float)columns)), y, w/((float)columns), h);
        lbl.text = [NSString stringWithFormat:@" %@ : %@",keys[i], result[keys[i]]];
        
        [scrollView addSubview:lbl];
    }
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, y + h);
}

// Hàm loại bỏ các ký tự dấu và từ tầm thường sau đó đếm các từ xuất hiện trong đoạn
- (NSMutableDictionary *) countWord{
    //Thay thế hết các separator bằng space
    for (int i=0; i < separator.count; i++)
    {
        self.data = [self.data stringByReplacingOccurrencesOfString:separator[i] withString:@" "];
    }
    
    // Biến 2 dấu cách liên tiếp nếu có thành 1 dấu
    while ([self.data rangeOfString:@"  "].location != NSNotFound)
    {
        self.data = [self.data stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    
    // Lấy mảng các từ
    NSArray *words = [self.data componentsSeparatedByString:@" "];
    
    NSMutableDictionary * result = [NSMutableDictionary new];
    
    for(NSString * word in words)
    {
        // Kiểm tra nếu có phải là từ tầm thường hay không
        if (word.length > 0 && [unwantedWords indexOfObject:word] == NSNotFound)
        {
            if ([result objectForKey:word] == nil)
                [result setObject:@1 forKey:word];
            else
                [result setObject:@(((NSNumber *)result[word]).intValue +1) forKey:word];
        }
    }
    
    return result;
}


// Hàm sắp xếp nhanh mảng nstring
-(NSArray *)quickSortString:(NSMutableArray *)unsortedDataArray
{
    
    NSMutableArray *lessArray = [[NSMutableArray alloc] init];
    NSMutableArray *greaterArray =[[NSMutableArray alloc] init];
    if ([unsortedDataArray count] < 1)
    {
        return nil;
    }
    
    int randomPivotPoint = arc4random() % [unsortedDataArray count];
    NSString *pivotValue = [unsortedDataArray objectAtIndex:randomPivotPoint];
    [unsortedDataArray removeObjectAtIndex:randomPivotPoint];
    
    for (NSString *item in unsortedDataArray)
    {
        if ([item caseInsensitiveCompare:pivotValue] == NSOrderedAscending)
        {
            [lessArray addObject:item];
        }
        else
        {
            [greaterArray addObject:item];
        }
    }
    
    NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
    [sortedArray addObjectsFromArray:[self quickSortString:lessArray]];
    [sortedArray addObject:pivotValue];
    [sortedArray addObjectsFromArray:[self quickSortString:greaterArray]];
    return sortedArray;
}
@end
