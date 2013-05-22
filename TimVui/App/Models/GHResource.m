#import "GHResource.h"
#import "TVNetworkingClient.h"
#import "TVAppDelegate.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
@interface GHResource ()
@property(nonatomic,strong)NSDictionary *data;
@property(nonatomic,strong)NSMutableArray *successBlocks;
@property(nonatomic,strong)NSMutableArray *failureBlocks;
@property(nonatomic,assign)GHResourceStatus resourceStatus;
@end


@implementation GHResource

- (id)initWithPath:(NSString *)path {
	self = [super init];
	if (self) {
		self.resourcePath = path;
		self.resourceStatus = GHResourceStatusUnloaded;
	}
	return self;
}

- (void)setHeaderValues:(NSDictionary *)values {
}

- (void)setValues:(id)response {
}

#pragma mark API


- (NSString *)resourceContentType {
	return kResourceContentTypeDefault;
}

- (TVNetworkingClient *)apiClient {
    return [TVNetworkingClient sharedClient];
}

- (NSMutableArray *)successBlocks {
    if (!_successBlocks) _successBlocks = [NSMutableArray array];
    return _successBlocks;
}

- (NSMutableArray *)failureBlocks {
    if (!_failureBlocks) _failureBlocks = [NSMutableArray array];
    return _failureBlocks;
}

- (void)whenLoaded:(resourceSuccess)success {
    if (self.isLoaded) {
        success(self, nil);
    } else {
        [self.successBlocks addObject:[success copy]];
    }
}

- (void)loadWithSuccess:(resourceSuccess)success {
	[self loadWithParams:nil path:self.resourcePath method:kRequestMethodGet start:nil success:success failure:nil];
}

- (void)loadWithParams:(NSDictionary *)params start:(resourceStart)start success:(resourceSuccess)success failure:(resourceFailure)failure {
	[self loadWithParams:params path:self.resourcePath method:kRequestMethodPost start:start success:success failure:failure];
}
- (void)loadWithParams:(NSDictionary *)params path:(NSString *)path method:(NSString *)method start:(resourceStart)start success:(resourceSuccess)success failure:(resourceFailure)failure {
    if (self.isLoading) {
        if (success) [self.successBlocks addObject:[success copy]];
        if (failure) [self.successBlocks addObject:[failure copy]];
        if (start) start(self);
        return;
    }
	self.error = nil;
	self.resourceStatus = GHResourceStatusLoading;
	NSMutableURLRequest *request = [self.apiClient requestWithMethod:method path:path parameters:params];
    
	request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

	void (^onSuccess)() = (void (^)()) ^(AFHTTPRequestOperation *operation, id data) {
            NSDictionary *headers = operation.response.allHeaderFields;
            //D3JLog(@"\n%@: Loading %@ finished.\n\n\nData:\n%@\n", self.class, path, data);
            [self setHeaderValues:headers];
            [self setValues:data];
            self.resourceStatus = GHResourceStatusLoaded;
            if (success) success(self, data);
            for (void (^block)() in self.successBlocks) {
                block(self, data);
            }
            [self.successBlocks removeAllObjects];
        };
	void (^onFailure)() = (void (^)()) ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSDictionary *headers = operation.response.allHeaderFields;
            DJLog(@"\n%@: Loading %@ failed.\n\nparams:\n%@\n\nError:\n%@\n", self.class, path, params, error);
            [self setHeaderValues:headers];
            self.error = error;
            self.resourceStatus = GHResourceStatusFailed;
            if (failure) failure(self, error);
            for (void (^block)() in self.failureBlocks) {
                block(self, error);
            }
            [self.failureBlocks removeAllObjects];
        };
    AFHTTPRequestOperation *operation;
    operation = [self.apiClient HTTPRequestOperationWithRequest:request success:(void (^)(AFHTTPRequestOperation *, id)) onSuccess failure:(void (^)(AFHTTPRequestOperation *, NSError *)) onFailure];
    [self.apiClient enqueueHTTPRequestOperation:operation];
	if (start) start(self);
}

- (void)saveWithParams:(NSDictionary *)values path:(NSString *)path method:(NSString *)method start:(resourceStart)start success:(resourceSuccess)success failure:(resourceFailure)failure {
	self.error = nil;
	NSMutableURLRequest *request = [self.apiClient requestWithMethod:method path:path parameters:values];
	D3JLog(@"\n%@: Saving %@ (%@) started.\n\nHeaders:\n%@\n\nData:\n%@\n", self.class, path, method, request.allHTTPHeaderFields, values);
	void (^onSuccess)() = (void (^)()) ^(NSURLRequest *request, NSHTTPURLResponse *response, id data) {
            NSDictionary *headers = response.allHeaderFields;
            D3JLog(@"\n%@: Saving %@ finished.\n\nHeaders:\n%@\n\nData:\n%@\n", self.class, path, headers, data);
            if (success) success(self, data);
        };
	void (^onFailure)() = (void (^)()) ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
            NSDictionary *headers = response.allHeaderFields;
            DJLog(@"\n%@: Saving %@ failed.\n\nHeaders:\n%@\n\nError:\n%@\n", self.class, path, headers, error);
            self.error = error;
            if (failure) failure(self, error);
        };
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:onSuccess failure:onFailure];
	[operation start];
	if (start) start(self);
}

#pragma mark Status

- (void)markAsUnloaded {
	self.resourceStatus = GHResourceStatusUnloaded;
}

- (void)markAsLoaded {
	self.resourceStatus = GHResourceStatusLoaded;
}

// only mark as changed if the resource was loaded before. otherwise mark as
// unloaded, so that it gets fully loaded the next time its data is needed.
- (void)markAsChanged {
	self.resourceStatus = self.isLoaded ? GHResourceStatusChanged : GHResourceStatusUnloaded;
}

- (BOOL)isFailed {
	return self.resourceStatus == GHResourceStatusFailed;
}

- (BOOL)isUnloaded {
	return self.resourceStatus <= GHResourceStatusUnloaded;
}

- (BOOL)isLoading {
	return self.resourceStatus == GHResourceStatusLoading;
}

// the resource is loaded if it has been marked as loaded or marked as changed
// after being loaded. also check for isChanged if you need current API data.
- (BOOL)isLoaded {
	return self.resourceStatus >= GHResourceStatusLoaded;
}

- (BOOL)isChanged {
	return self.resourceStatus == GHResourceStatusChanged;
}

- (BOOL)isEmpty {
	return self.resourceStatus <= GHResourceStatusLoading;
}

@end
