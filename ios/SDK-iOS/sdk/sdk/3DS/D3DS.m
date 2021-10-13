#import "D3DS.h"

@interface D3DS (Private)
@end

NSString * const POST_BACK_URL = @"https://demo.cloudpayments.ru/WebFormPost/GetWebViewData";

@implementation D3DS

-(void) make3DSPaymentWithUIViewController: (UIViewController<D3DSDelegate> *) viewController andAcsURLString: (NSString *) acsUrlString andPaReqString: (NSString *) paReqString andTransactionIdString: (NSString *) transactionIdString {
    
    /*[request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];*/
    
    viewControllerD3DSDelegate = viewController;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: acsUrlString]];
    [request setHTTPMethod: @"POST"];
    [request setCachePolicy: NSURLRequestReloadIgnoringCacheData];
    NSMutableString *requestBody;
    requestBody = [NSMutableString stringWithString: @"MD="];
    [requestBody appendString: transactionIdString];
    [requestBody appendString: @"&PaReq="];
    [requestBody appendString: paReqString];
    [requestBody appendString: @"&TermUrl="];
    [requestBody appendString: POST_BACK_URL];
    [request setHTTPBody:[[requestBody stringByReplacingOccurrencesOfString: @"+" withString: @"%2B"] dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request body %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);

    [[NSURLCache sharedURLCache] removeCachedResponseForRequest: request];

    NSHTTPURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    
    if (([response statusCode] == 200) || ([response statusCode] == 201)) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        webView = [[WKWebView alloc] initWithFrame:viewControllerD3DSDelegate.view.frame configuration:configuration];
        [webView setNavigationDelegate: self];
        [viewControllerD3DSDelegate.view addSubview:webView];
        
        [webView loadData:responseData MIMEType:[response MIMEType] characterEncodingName:[response textEncodingName] baseURL:[response URL]];
      
    } else {
        NSString *messageString = [NSString stringWithFormat:@"Unable to load 3DS autorization page.\nStatus code: %d", (unsigned int)[response statusCode]];
        [viewControllerD3DSDelegate authorizationFailedWithHtml:messageString];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSURL *url = webView.URL;
    if ([url.absoluteString isEqualToString:POST_BACK_URL]) {
        __weak typeof(self) wself = self;
        [webView evaluateJavaScript:@"document.documentElement.outerHTML.toString()" completionHandler:^(NSString *_Nullable result, NSError * _Nullable error) {
            __strong typeof(wself) sself = wself;
            NSString *str = result;
            do {
                NSRange startRange = [str rangeOfString:@"{"];
                if (startRange.location == NSNotFound) {
                    break;
                }
                str = [str substringFromIndex:startRange.location];
                NSRange endRange = [str rangeOfString:@"}"];
                if (endRange.location == NSNotFound) {
                    break;
                }
                str = [str substringToIndex:endRange.location + 1];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
                [sself->viewControllerD3DSDelegate authorizationCompletedWithMD:dict[@"MD"] andPares:dict[@"PaRes"]];
                [webView removeFromSuperview];
                return;
            } while(NO);
            [sself->viewControllerD3DSDelegate authorizationFailedWithHtml:str];
            [webView removeFromSuperview];
        }];
    } 
}

@end
