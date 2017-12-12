//
//  ViewController.m
//  AlivcFilterShowcase
//
//  Created by Worthy on 2017/12/5.
//  Copyright © 2017年 worthyzhang. All rights reserved.
//

#import "ViewController.h"
#import "AlivcFilter.h"

@interface ViewController() <NSTableViewDelegate, NSTableViewDataSource, DragViewDelegate>
@property (nonatomic, strong) NSMutableArray *filters;
@property (nonatomic, strong) GPUImagePicture *image;
@property (nonatomic, strong) AlivcFilter *filter;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, copy) NSString *filePath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFilters];
    _glView.delegate = self;
    [_tableView reloadData];

}

- (void)loadFilters {
   NSString *root = [[NSBundle mainBundle] pathForResource:@"filters" ofType:nil];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:root error:nil];
    _filters = [NSMutableArray array];
    for (NSString *dirname in contents) {
        [_filters addObject:[root stringByAppendingPathComponent:dirname]];
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)applyFilter:(NSInteger)filterRow {
    NSString *dir = _filters[filterRow];
    if (!_image) {
        return;
    }
    [_image removeAllTargets];
    [_filter remove];
    NSString *configPath = [dir stringByAppendingPathComponent:@"config.json"];
    _filter = [[AlivcFilter alloc] initWithConfigPath:configPath];
    [_image addTarget:_filter.filter atTextureLocation:0];
    [_filter.filter addTarget:_glView];
    
    [_filter process];
    [_image processImage];
}

#pragma mark - tableview delegate

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _filters.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *path = _filters[row];
    return [path lastPathComponent];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [[notification object] selectedRow];
    _selectedRow = row;
    [self applyFilter:row];
}

#pragma mark - dragview delegate

- (void)didDragFile:(NSString *)path {
    _filePath = path;
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:path];
    _image = [[GPUImagePicture alloc] initWithImage:img];
    CGSize size = [_image outputImageSize];
    _widthConstraint.constant = size.width;
    _heightConstraint.constant = size.height;
    [self.view setNeedsLayout:YES];
    [self.view layoutSubtreeIfNeeded];
    [self applyFilter:_selectedRow];
}

#pragma mark - action

- (IBAction)save:(id)sender {
    NSString *root = [_filePath stringByDeletingLastPathComponent];
    NSString *name = [_filters[_selectedRow] lastPathComponent];
    NSString *savePath = [root stringByAppendingString:[NSString stringWithFormat:@"/%@.png", name]];
    
    NSBitmapImageRep *bitmap = [_glView bitmapImageRepForCachingDisplayInRect:_glView.bounds];
    [_glView cacheDisplayInRect:_glView.bounds toBitmapImageRep:bitmap];
    NSData *data = [bitmap representationUsingType: NSPNGFileType properties: nil];
    [data writeToFile:savePath atomically: NO];
    
}

@end
