//
//  RecordsOfGameSnece.m
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 1/6/16
//
//  Copyright (c) 2016 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------
#import "RecordsOfGameScene.h"
#import "MySqlDB.h"
#import "ParseDB.h"


//CCLabelTTF* leadersBoard;
NSString* DBText;
UITableView* tableView;

NSString* login;
CCLabelTTF* text;
CCLabelTTF* text2;
CCButton* create;
CCButton* okButton;
UITextField* field;
NSUserDefaults* savedLogin;
NSUserDefaults* savedID;
CCLabelTTF* tooShortError;


CCLabelTTF* errorLogin;

CCLabelTTF* waitingWhileDownloading;
// -----------------------------------------------------------------
CGSize size;

@interface RecordsOfGameScene ()
{
    ParseDB *_homeModel;
    NSArray *_feedItems;
}
@property (strong, nonatomic) UITableViewCell *recordsCell;

@end

@implementation RecordsOfGameScene 

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    // 'layer' is an autorelease object.
    RecordsOfGameScene *layer = [RecordsOfGameScene node];
    // add layer as a child to scene
    [scene addChild: layer];
    // return the scene
    return scene;
}
// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    size = [[CCDirector sharedDirector] viewSize];
    [self addButtonReturn];
    
    waitingWhileDownloading = [CCLabelTTF labelWithString:@"waitingWhileDownloading" fontName:@"AppleGothic" fontSize:16];
    waitingWhileDownloading.position = ccp(size.width/2, size.height*5/10);
    [self addChild:waitingWhileDownloading];
    
//    //таблица контейнер для базы
//    tableView = [[UITableView alloc] initWithFrame:CGRectMake(101, 145, 350, 116)];
//    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [[[CCDirector sharedDirector] view] addSubview:tableView];
//    self.listTableView = tableView;
//    self.listTableView.delegate = self;
//    self.listTableView.dataSource = self;
//    
//    self.listTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
//    self.recordsCell = [self.listTableView dequeueReusableCellWithIdentifier:@"Cell"];
//    self.recordsCell.hidden = NO;
//    self.recordsCell.backgroundColor = [UIColor cyanColor];
//    [self.listTableView reloadData];
//    [[[CCDirector sharedDirector] view] addSubview:self.listTableView];
//    // Set this view controller object as the delegate and data source for the table view
//    
//    // Create array object and assign it to _feedItems variable
//    _feedItems = [[NSArray alloc] init];
//    // Create new HomeModel object and assign it to _homeModel variable
//    _homeModel = [[ParseDB alloc] init];
//    // Set this view controller object as the delegate for the home model object
//    _homeModel.delegate = self;
//    // Call the download items method of the home model object
//    [_homeModel downloadItems];
    
 //   вызов метода обновления
 //   [_homeModel downloadItems];
    
    [self verifyNetworkConnectoin];
    [self verifyUserLogin];

    return self;
}

-(void)updateTableList{

    NSLog(@"AAAALERT3");

    [self removeChild:waitingWhileDownloading];
    NSLog(@"AAAALERT4");

    //таблица контейнер для базы
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(101, 145, 350, 116)];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[[CCDirector sharedDirector] view] addSubview:tableView];
    self.listTableView = tableView;
    NSLog(@"AAAALERT5");

    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    NSLog(@"AAAALERT6");

    self.listTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.recordsCell = [self.listTableView dequeueReusableCellWithIdentifier:@"Cell"];
    self.recordsCell.hidden = NO;
    self.recordsCell.backgroundColor = [UIColor cyanColor];
    NSLog(@"AAAALERT7");

    [self.listTableView reloadData];
    NSLog(@"AAAALERT8");

    [[[CCDirector sharedDirector] view] addSubview:self.listTableView];
    NSLog(@"AAAALERT9");
    // Create array object and assign it to _feedItems variable
    _feedItems = [[NSArray alloc] init];
    // Create new HomeModel object and assign it to _homeModel variable
    _homeModel = [[ParseDB alloc] init];
    // Set this view controller object as the delegate for the home model object
    _homeModel.delegate = self;
    // Call the download items method of the home model object
    [_homeModel downloadItems];
    
}

//1метод проверки соединения с интернетом
-(void)verifyNetworkConnectoin{
    Reachability  *hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    NSString *resultValue = nil;
    if (netStatus == NotReachable) {
        resultValue = @"Not Connection";
    } else if (netStatus == ReachableViaWiFi) {
        resultValue = @"Connection ReachableViaWiFi";
    } else if (netStatus == ReachableViaWWAN) {
        resultValue = @"Connection ReachableViaWWAN";
    }
    CCLabelTTF* netStat = [CCLabelTTF labelWithString:resultValue fontName:@"AppleGothic" fontSize:14];
    netStat.position = ccp(size.width/2, size.height*9.5/10);
    [self addChild:netStat];
    
    [self updateTableList];

}

//2проверка наличия логина
-(void)verifyUserLogin{

    NSLog (@"savedLogin is - %@.", [savedLogin objectForKey:@"username"]);
    if ([savedLogin objectForKey:@"username"] == nil) {
        //нужна регистрация
        text = [CCLabelTTF labelWithString:@"you have no nickname" fontName:@"AppleGothic" fontSize:16];
        text.position = ccp(size.width/2, size.height*8/10);
        [self addChild:text];
        create = [CCButton buttonWithTitle:@"create" fontName:@"Verdana-Bold" fontSize:14];
        create.positionInPoints = ccp(size.width/2, size.height*7.5/10);
        [create setTarget:self selector:@selector(openNameField:)];
        [self addChild:create z:3];
    }
    else{
    //вход
    //передать логин и лучший результат
    NSLog (@"ВХОД");
    [self sendNewBestResult];
    }
}
//3 открыть поле ввода логина
-(void)openNameField:(id)sender{
    [self removeChild:text];
    [self removeChild:create];
    text2 = [CCLabelTTF labelWithString:@"enter" fontName:@"AppleGothic" fontSize:16];
    text2.position = ccp(size.width/2, size.height*8/10);
    [self addChild:text2];
    field = [[UITextField alloc] initWithFrame:CGRectMake(150, 80, 150, 25)];
    field.text = @"";
    field.backgroundColor = [UIColor whiteColor];
    [[[CCDirector sharedDirector] view] addSubview:field];

    okButton = [CCButton buttonWithTitle:@"OK" fontName:@"Verdana-Bold" fontSize:14];
    okButton.positionInPoints = ccp(size.width/2, size.height*6.5/10);
    [okButton setTarget:self selector:@selector(goNext:)];
    [self addChild:okButton z:5];
    [field becomeFirstResponder]; //показать клавиатуру
    NSLog(@"kjgvj");
    
    }

-(void)goNext2:(id)sender{
}
//4проверка логина
-(void)goNext:(id)sender{
    [field resignFirstResponder]; //скрыть клавиатуру
    login = field.text;
    if (login.length < 4) {
        tooShortError = [CCLabelTTF labelWithString:@"login is too short" fontName:@"AppleGothic" fontSize:14];
        tooShortError.color = [CCColor redColor];
        tooShortError.position = ccp(size.width/2, size.height*9/10);
        [self addChild:tooShortError];
        login = nil;
        [okButton setTarget:self selector:@selector(goPrevius:)];
    }
    else
    [self sendLoginToServer];
    
}

-(void)goPrevius:(id)sender{
    [errorLogin setVisible:NO];
    [self removeChild:okButton];
    [self removeChild:text2];
    [self removeChild:tooShortError];
    
    errorLogin = nil;
    [field removeFromSuperview];
    [self verifyUserLogin];
}
-(void)goPrevius2:(id)sender{
    [self removeChild:errorLogin];
    [self removeChild:okButton];
    [self removeChild:text2];
    [field removeFromSuperview];
    [self verifyUserLogin];
}
-(void)exitFromSendingLogin{
    [okButton setTarget:self selector:@selector(goPrevius2:)];
}

//2.1 если логин сохрaнен в кеш, тогда сравнить результаты и внести новый
-(void)sendNewBestResult{
    
    float bestScore = [SafeScoreClass showTheBestScore];
    if (bestScore > [[savedBestScore objectForKey:@"bestScore"] floatValue]){
    [savedBestScore setFloat:bestScore forKey:@"bestScore"];
        NSLog(@"new best score %f", bestScore);
        NSString* cop = [NSString stringWithFormat:@"%f", bestScore];
    //метка входа для php файла
        NSString* t = @"1";
        NSString* l = [[NSString alloc] initWithString:[savedLogin objectForKey:@"username"]];
        NSString* sc = [[NSString alloc] initWithString:cop];
        NSString* newStr = [NSString stringWithFormat:@"l=%@&sc=%@&t=%@", l, sc, t];
        NSLog(@"newStr - %@", [newStr description]);
        
        NSData *postData = [newStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
 //       [request setURL:[NSURL URLWithString:@"http://chickens.goldlans.com/index.php"]];
        [request setURL:[NSURL URLWithString:@"http://chickens.goldlans.com/addToDB.php"]];

        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSLog(@"Request - %@", [request description]);
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];

        NSURLResponse* responce;
        NSData* getReply = 	[NSURLConnection sendSynchronousRequest:request returningResponse:&responce error:nil];
        NSString* theReply = [[NSString alloc] initWithBytes:[getReply bytes] length:[getReply length] encoding:NSASCIIStringEncoding];
        NSLog(@"!!!%@ reply", theReply);
        if ([theReply isEqualToString:@"WTF error"]){
            NSLog(@"WTF error presenT!");
        }
        
        if (connection) {
            NSLog(@"connected");
            self.infoData = [NSMutableData data];
        } else {
            NSLog(@"Connection failed");
        }
        
        NSString* updated = @"data base is updated";
        if ([theReply isEqualToString:updated]) {
            NSLog(@"updated");
            
        }
       
        
     }
    
    else{
    //exit
    }
    
    
}

//5 отправка логина на сервер
-(void)sendLoginToServer{
    float bestScore = [SafeScoreClass showTheBestScore];
    NSLog(@"score %f", bestScore);
    NSString* cop = [NSString stringWithFormat:@"%f", bestScore];
    //метка регистрации для php файла
    NSString* t = @"2";
    
    NSString* l = [[NSString alloc] initWithString:login];
    NSString* sc = [[NSString alloc] initWithString:cop];
    NSString* newStr = [NSString stringWithFormat:@"l=%@&sc=%@&t=%@", l, sc, t];
    NSLog(@"newStr - %@", [newStr description]);

    NSData *postData = [newStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://chickens.goldlans.com/index.php"]];

    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    NSLog(@"Request - %@", [request description]);
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];

    NSURLResponse* responce;
    NSData* getReply = 	[NSURLConnection sendSynchronousRequest:request returningResponse:&responce error:nil];
    NSString* theReply = [[NSString alloc] initWithBytes:[getReply bytes] length:[getReply length] encoding:NSASCIIStringEncoding];
    NSString* shortReply = [theReply substringToIndex:1];
    NSLog(@"%@ reply", theReply);
    NSLog(@"%@shortReply", shortReply);

        if (connection) {
        NSLog(@"a connected");
        self.infoData = [NSMutableData data];
        } else {
        NSLog(@"Connection failed");
        }

    NSString* error = @"1";
    if ([shortReply isEqualToString:error]) {
        NSLog(@"errrroooorr");
        errorLogin = [CCLabelTTF labelWithString:@"Login already exists. Try another" fontName:@"AppleGothic" fontSize:14];
        errorLogin.color = [CCColor redColor];
        errorLogin.position = ccp(size.width/2, size.height*9/10);
        [self addChild:errorLogin];
        login = nil;
        [self exitFromSendingLogin];
    }
    NSString* error3 = @"ERROR Request";
    if ([theReply isEqualToString:error3]) {
        NSLog(@"ERROR DB");
        CCLabelTTF* errorLogin = [CCLabelTTF labelWithString:@"Error!" fontName:@"AppleGothic" fontSize:14];
        errorLogin.color = [CCColor redColor];
        errorLogin.position = ccp(size.width/2, size.height*9/10);
        [self addChild:errorLogin];
        
        [self removeChild:okButton];
        [self removeChild:text2];
        [field removeFromSuperview];
        [self exitFromSendingLogin];
    }

    //хранит имя пользователя в кєше
    savedLogin = [NSUserDefaults standardUserDefaults];
    [savedLogin setObject:login forKey:@"username"];
    savedBestScore = [NSUserDefaults standardUserDefaults];
    [savedBestScore setFloat:bestScore forKey:@"bestScore"];
    NSLog(@"Всъе");
        NSLog(@"%@",[savedLogin objectForKey:@"username"]);
        NSLog(@"%@",[savedBestScore objectForKey:@"bestScore"]);

        CCLabelTTF* loginAdded = [CCLabelTTF labelWithString:@"YOUR login" fontName:@"AppleGothic" fontSize:14];
        loginAdded.color = [CCColor redColor];
        loginAdded.position = ccp(size.width/2, size.height*9/10);
        [self addChild:loginAdded];
        
        [self removeChild:okButton];
        [self removeChild:text2];
        [field removeFromSuperview];
}







-(void)itemsDownloaded:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    NSLog(@"Problem0");
    // Set the downloaded items to the array
    _feedItems = items;
    NSLog(@"Problem1");

    // Reload the table view
    [self.listTableView reloadData];
}

#pragma mark Table View Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of feed items (initially 0)
    return _feedItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSLog(@"_feedItems   %@", _feedItems);
    
    
//  NSError *error;
//   NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_feedItems options:NSJSONReadingAllowFragments error:&error];
//    NSLog(@"json array is - %@", jsonArray);
//
//        NSDictionary *jsonElement = jsonArray[i];
//        MySqlDB *newDB = [[MySqlDB alloc] init];
//        newDB.score = jsonElement[@"cop"];
//        newDB.idi = jsonElement[@"id"];
//        newDB.nick = jsonElement[@"nic"];
//        
//        // Add this question to the locations array
//        [_chickenResult addObject:newDB];


    MySqlDB *item = [[MySqlDB alloc] init];
//    newItem.score = jsonArray[@"cop"];
//    newItem.idi = jsonArray[@"id"];
//    newItem.nick = jsonArray[@"nic"];
    item = [_feedItems objectAtIndex:indexPath.row];
//    NSLog(@"item %@", [item description]);
//    NSError *error;
//    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[_feedItems objectAtIndex:indexPath.row] options:NSJSONReadingAllowFragments error:&error];
//    NSDictionary *jsonElement = [jsonArray objectAtIndex:indexPath.row];
//    MySqlDB* newBase = [[MySqlDB alloc] init];
//    
//    newBase.score = [NSString stringWithFormat:@"%@", jsonElement];
//    item.score = jsonArray[@"cop"];
//    item.idi = jsonArray[@"id"];
//    item.nick = jsonArray[@"nic"];
//    NSLog(@"idi log %@ ", item.idi);
    NSString* all = [NSString stringWithFormat:@"#%@ name: %@  best score: %@", item.idi, item.nick, item.score];
   // NSString* all = [NSString stringWithFormat:@"#%@", [_feedItems description]];

    // Get references to labels of cell
    // myCell.textLabel.text = [NSString stringWithFormat:@"%@ %@", item.score, item.nick];
     myCell.textLabel.text = all;

    return myCell;
}


//--------------------------------------------------------------------

-(void)addButtonReturn{
    [self stopAllActions];
    CCButton* returnToMenu = [CCButton buttonWithTitle:@"Return to menu" fontName:@"Verdana-Bold" fontSize:18];
    returnToMenu.positionInPoints = ccp(size.width/2, size.height*1/10);
    [returnToMenu setTarget:self selector:@selector(getToRecordsScene:)];
    [self addChild:returnToMenu z:3];
}

-(void)getToRecordsScene:(id)sender{

 //   [field removeFromSuperview];
    [tableView removeFromSuperview];
 //   [self removeChild:text2];
    self.listTableView = nil;
    tableView = nil;

    Class SceneClass = NSClassFromString(@"MenuScene");
    [[CCDirector sharedDirector] replaceScene:[SceneClass scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:1.0f]];
    
}
// -----------------------------------------------------------------

@end





