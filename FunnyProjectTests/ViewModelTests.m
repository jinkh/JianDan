//
//  FunnyProjectTests.m
//  FunnyProjectTests
//
//  Created by Zinkham on 16/8/31.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ArticleViewModel.h"
#import "PictureViewModel.h"
#import "JokeViewModel.h"
#import "VideoViewModel.h"

@interface ViewModelTests : XCTestCase
{
@private
    ArticleViewModel *articleViewModel;
    PictureViewModel *picViewModel;
    JokeViewModel *jokeViewModel;
    VideoViewModel *videoViewModel;
    
}

@end

@implementation ViewModelTests

- (void)setUp {
    [super setUp];
    articleViewModel = [[ArticleViewModel alloc] init];
    picViewModel = [[PictureViewModel alloc] initWithUrl:BoredPicturesUrl];
    jokeViewModel = [[JokeViewModel alloc] init];
    videoViewModel = [[VideoViewModel alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testFetchNewArticleList
{
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testFetchNewArticleList"];
    [articleViewModel fetchNewArticleList:^(NetReturnValue *returnValue) {
        XCTAssertNotNil(returnValue.data);
        [expectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testFetchNextNewArticleList
{
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testFetchNextNewArticleList"];
    [articleViewModel fetchNextNewArticleList:^(NetReturnValue *returnValue) {
        XCTAssertNotNil(returnValue.data);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}


- (void)testfetchPictureList
{
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testfetchPictureList"];
    [picViewModel fetchPictureList:^(NetReturnValue *returnValue) {
        XCTAssertNotNil(returnValue.data);
        [expectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testfetchNextPictureList
{
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testfetchNextPictureList"];
    [picViewModel fetchNextPictureList:^(NetReturnValue *returnValue) {
        XCTAssertNotNil(returnValue.data);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testfetchJokeList
{
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testfetchJokeList"];
    [jokeViewModel fetchJokeList:^(NetReturnValue *returnValue) {
        XCTAssertNotNil(returnValue.data);
        [expectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testfetchNextJokeList
{
    __weak  XCTestExpectation *expectation = [self expectationWithDescription:@"testfetchNextJokeList"];
    [jokeViewModel fetchNextJokeList:^(NetReturnValue *returnValue) {
        XCTAssertNotNil(returnValue.data);
        [expectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testFetchVideoList
{
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testFetchVideoList"];
    [videoViewModel fetchVideoList:^(NetReturnValue *returnValue) {
        XCTAssertNotNil(returnValue.data);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testFetchNextVideoList
{
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testFetchNextVideoList"];
    [videoViewModel fetchNextVideoList:^(NetReturnValue *returnValue) {
        XCTAssertNotNil(returnValue.data);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
