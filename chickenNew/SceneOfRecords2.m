//
//  SceneOfRecords2.m
//
//  Created by : dchernega
//  Project    : safeMyChicken
//  Date       : 7/21/16
//
//  Copyright (c) 2016 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "MySqlDB.h"
#import "SceneOfRecords2.h"

// -----------------------------------------------------------------
CGSize size;
CCLabelTTF* waitingWhileDownloading;
UITableView* tableView;
NSUserDefaults* savedLogin;
NSUserDefaults* savedBestScore2;
CCLabelTTF* text1;
CCButton* create;
CCLabelTTF* text2;
UITextField* field;
CCButton* okButton;
CCButton* okButton2;
CCButton* okButton3;

NSString* login;
CCLabelTTF* tooShortError;
CCLabelTTF* errorLogin;
CCLabelTTF* errorOfRequiredSymbols;
CCLabelTTF* yourPosition;
NSMutableArray* arrayOfCurrentPosInTableScore;
@interface SceneOfRecords2 ()
{
    ParseDB *_homeModel;
    NSArray *_feedItems;
}
@property (strong, nonatomic) UITableViewCell *recordsCell;
@end


@implementation SceneOfRecords2

// -----------------------------------------------------------------

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    // 'layer' is an autorelease object.
    SceneOfRecords2 *layer = [SceneOfRecords2 node];
    // add layer as a child to scene
    [scene addChild: layer];
    // return the scene
    return scene;
}

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    //установили размер экрана
    size = [[CCDirector sharedDirector] viewSize];

    CCSprite* foregroungImage = [CCSprite spriteWithImageNamed:@"fon.png"];
    foregroungImage.position = ccp(size.width/2 , size.height/2);
    foregroungImage.scale = 0.57;
    [self addChild:foregroungImage z:0];
    
    //сообщение с предупреждением подождать конца загрузки
    waitingWhileDownloading = [CCLabelTTF labelWithString:@"waitingWhileDownloading" fontName:@"AppleGothic" fontSize:16];
    waitingWhileDownloading.position = ccp(size.width/2, size.height*5/10);
    [self addChild:waitingWhileDownloading];
    
    //проверка соединие с интернетом
    [self verifyNetworkConnectoin];

    //таблица контейнер для базы
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(150, 145, 400, 116)];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[[CCDirector sharedDirector] view] addSubview:tableView];
    self.listTableView = tableView;
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.recordsCell = [self.listTableView dequeueReusableCellWithIdentifier:@"Cell"];
    self.recordsCell.hidden = NO;
    self.recordsCell.backgroundColor = [UIColor cyanColor];
    [self.listTableView reloadData];
    [[[CCDirector sharedDirector] view] addSubview:self.listTableView];
    
    // Create array object and assign it to _feedItems variable
 //   _feedItems = [[NSArray alloc] init];
    // Create new HomeModel object and assign it to _homeModel variable
    _homeModel = [[ParseDB alloc] init];
    // Set this view controller object as the delegate for the home model object
    _homeModel.delegate = self;
    // Call the download items method of the home model object
    [_homeModel downloadItems];
    
    [self verifyUserLogin];

    CCButton* exitButton = [[CCButton alloc] initWithTitle:@"exit" fontName:@"Verdana-Bold" fontSize:18];
    exitButton.positionInPoints = ccp(size.width/2, size.height/11);
    [exitButton setTarget:self selector:@selector(goToMainMenu:)];
    [self addChild:exitButton z:5];
    
    return self;
}
// -----------------------------------------------------------------

-(void) newTableListCreate{
    
    //таблица контейнер для базы
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(150, 145, 400, 116)];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[[CCDirector sharedDirector] view] addSubview:tableView];
    self.listTableView = tableView;
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.recordsCell = [self.listTableView dequeueReusableCellWithIdentifier:@"Cell"];
    self.recordsCell.hidden = NO;
    self.recordsCell.backgroundColor = [UIColor cyanColor];
    [self.listTableView reloadData];
    [[[CCDirector sharedDirector] view] addSubview:self.listTableView];
    
    // Create array object and assign it to _feedItems variable
    //   _feedItems = [[NSArray alloc] init];
    // Create new HomeModel object and assign it to _homeModel variable
    _homeModel = [[ParseDB alloc] init];
    // Set this view controller object as the delegate for the home model object
    _homeModel.delegate = self;
    // Call the download items method of the home model object
    [_homeModel downloadItems];
    
    [self verifyUserLogin];
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

//2если интернет есть, то внести данные в лист
-(void)updateTableList{
    NSLog(@"AAAALERT3");
   // [self removeChild:waitingWhileDownloading];
    NSLog(@"AAAALERT4");
    
    //таблица контейнер для базы
   // tableView = [[UITableView alloc] initWithFrame:CGRectMake(101, 145, 100, 116)];
   // tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   // [[[CCDirector sharedDirector] view] addSubview:tableView];
   // self.listTableView = tableView;
    NSLog(@"AAAALERT55");
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark Table View Delegate Methods
// Return the number of feed items (initially 0)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_feedItems.count > 30)
    return 30;
    else
    return _feedItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"AAAALERT5");
    static NSString *CellIdentifier = @"Cell";
    //Поиск ячейки
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //Если ячейка не найдена
    if (myCell == nil) {
    //Создание ячейки
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSLog(@"AAAALERT5.1");

    MySqlDB *item = [[MySqlDB alloc] init];
    item = [_feedItems objectAtIndex:indexPath.row];
    NSLog(@"AAAALERT5.2");

    NSString* all = [NSString stringWithFormat:@"#%@ name: %@  best score: %@", item.idi, item.nick, item.score];
    myCell.textLabel.text = all;
    return myCell;
}

//2.5 загрузка данных в таблицу завершена
-(void)itemsDownloaded2:(NSArray *)items
{
  // This delegate method will get called when the items are finished downloading
    NSLog(@"Problem0");
  //  сортировать полученый массив по лучшему результату
    NSSortDescriptor* sortArrayByScore = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO selector:@selector(localizedStandardCompare:)];
    NSMutableArray* sortedChickenResult = [NSMutableArray arrayWithObject:sortArrayByScore];
    NSArray *_sortedArray = [items sortedArrayUsingDescriptors:sortedChickenResult];
    NSMutableArray *_chickenResult2 = [[NSMutableArray alloc] initWithArray:_sortedArray];
    
    
  //высчитать текущую позицию игрока в таблице
    if (savedLogin!= nil){
        arrayOfCurrentPosInTableScore = [[NSMutableArray alloc] init];
        NSString* findname = [savedLogin objectForKey:@"username"];
        NSLog(@"savedLogin= %@", findname);
        
        for(int i = 0; i < _chickenResult2.count; i++)
        {
            MySqlDB* dictionaryOfCurrentPosition = [[MySqlDB alloc] init];

            dictionaryOfCurrentPosition = [_chickenResult2 objectAtIndex:i];
            NSString* findMyNickname = [NSString stringWithFormat:@"%@",dictionaryOfCurrentPosition.nick];
            
            if([findMyNickname isEqualToString:findname])
            {
                NSString* a1 = [NSString stringWithFormat:@"%@",findMyNickname];
                [arrayOfCurrentPosInTableScore addObject:a1];

                NSString* pos2 = [NSString stringWithFormat:@"%i",i];
                [arrayOfCurrentPosInTableScore addObject:pos2];
                NSString* last3 = [NSString stringWithFormat:@"%lu", (unsigned long)_chickenResult2.count];
                [arrayOfCurrentPosInTableScore addObject:last3];
                NSLog(@"entries description %@ %@ %@", a1, pos2, last3);
                break;
            }
        }
        NSLog(@"entries description %@", arrayOfCurrentPosInTableScore);
        [self showThePositionOf:[savedLogin objectForKey:@"username"]];
    }
    
        
  // Set the downloaded items to the array
    _feedItems = _chickenResult2;
    NSLog(@"Problem1");
  // Reload the table view
    [self.listTableView reloadData];
    
}

//3 проверка существует ли ранее созданый логин в UserDefaults. Если да, то проверить новый рекорд. Если нет, то создать логин.
-(void)verifyUserLogin{
    NSLog(@"saved login is - %@", savedLogin);
   if (savedLogin == nil)
   {
       //нужна регистрация
      text1 = [[CCLabelTTF alloc] initWithString:@"you have no nickname" fontName:@"Verdana-Bold"  fontSize:16];
       text1.position = ccp(size.width/2, size.height*8/10);
       text1.scale =0.1;
       [self addChild:text1];
       
       CCActionScaleTo *scale = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
       CCActionFadeIn *fade = [[CCActionFadeIn alloc] initWithDuration:1];
       CCActionSpawn* spawn = [[CCActionSpawn alloc] initOne:scale two:fade];
       [text1 runAction:spawn];
       
       create = [CCButton buttonWithTitle:@"create" fontName:@"Verdana-Bold" fontSize:14];
       create.positionInPoints = ccp(size.width/2, size.height*7.5/10);
       create.scale =0.1;
       [create setTarget:self selector:@selector(goNext:)];
       [self addChild:create z:5];
       
       CCActionScaleTo *scale2 = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
       CCActionFadeIn *fade2 = [[CCActionFadeIn alloc] initWithDuration:1];
       CCActionSpawn* spawn2 = [[CCActionSpawn alloc] initOne:scale2 two:fade2];
       [create runAction:spawn2];
       
   }
   else{
      //если логин уже есть, то передать на сервер новый лучший результат
       [self verifyNewBestScore];
   }
}
-(void)goNext:(id)sender{
    [self openWindowToCreateLogin];
}

//4 открыть поле ввода логина
-(void)openWindowToCreateLogin{
    NSLog(@"!E7");
    [text1 setVisible:NO];
    [create setVisible:NO];
    
    text2 = [CCLabelTTF labelWithString:@"enter" fontName:@"AppleGothic" fontSize:16];
    text2.position = ccp(size.width/2, size.height*8/10);
    text2.scale = 0.1;
    [text2 setVisible:YES];
    [self addChild:text2];
    
    CCActionScaleTo *scale = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
    CCActionFadeIn *fade = [[CCActionFadeIn alloc] initWithDuration:1];
    CCActionSpawn* spawn = [[CCActionSpawn alloc] initOne:scale two:fade];
    [text2 runAction:spawn];
    
    field = [[UITextField alloc] initWithFrame:CGRectMake(150, 80, 150, 25)];
    field.text = @"";
    field.backgroundColor = [UIColor whiteColor];
    [[[CCDirector sharedDirector] view] addSubview:field];
    
    okButton = [CCButton buttonWithTitle:@"OK" fontName:@"Verdana-Bold" fontSize:14];
    okButton.positionInPoints = ccp(size.width/2, size.height*6.5/10);
    okButton.scale = 0.1;
    [okButton setTarget:self selector:@selector(verifyCreatedLogin:)];
    [self addChild:okButton z:5];
    
    CCActionScaleTo *scale2 = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
    CCActionFadeIn *fade2 = [[CCActionFadeIn alloc] initWithDuration:1];
    CCActionSpawn* spawn2 = [[CCActionSpawn alloc] initOne:scale2 two:fade2];
    [okButton runAction:spawn2];
    
    [field becomeFirstResponder]; //показать клавиатуру
    NSLog(@"kjgvj");
}

//5 проверяем новый логин. Если не подходит, возвращаемся к предыдущему шагу
-(void)verifyCreatedLogin:(id)sender{
    NSLog(@"1");
    [text2 setVisible:NO];
    [okButton setVisible:NO];
    NSLog(@"2");


    NSLog(@"!E0");
    [field resignFirstResponder]; //скрыть клавиатуру
    NSLog(@"!E1");
    login = field.text;
    NSLog(@"!E2");
    
    okButton2 = [CCButton buttonWithTitle:@"OK" fontName:@"Verdana-Bold" fontSize:14];
    okButton2.positionInPoints = ccp(size.width/2, size.height*6.5/10);
    okButton2.color = [CCColor redColor];
    
   
    if (login.length < 4 || login.length > 20){
    if (login.length < 4) {
        tooShortError = [CCLabelTTF labelWithString:@"login is too short" fontName:@"AppleGothic" fontSize:14];
        tooShortError.color = [CCColor redColor];
        tooShortError.position = ccp(size.width/2, size.height*9/10);
        tooShortError.scale =0.1;
        [self addChild:tooShortError];
        
        CCActionScaleTo *scale = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
        CCActionFadeIn *fade = [[CCActionFadeIn alloc] initWithDuration:1];
        CCActionSpawn* spawn = [[CCActionSpawn alloc] initOne:scale two:fade];
        [tooShortError runAction:spawn];
        
        
        NSLog(@"!E3");
        login = nil;
        NSLog(@"!E4");
        
    }
    if (login.length > 20){
        tooShortError = [CCLabelTTF labelWithString:@"login is too long" fontName:@"AppleGothic" fontSize:14];
        tooShortError.color = [CCColor redColor];
        tooShortError.position = ccp(size.width/2, size.height*9/10);
        tooShortError.scale =0.1;
        [self addChild:tooShortError];
        
        CCActionScaleTo *scale = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
        CCActionFadeIn *fade = [[CCActionFadeIn alloc] initWithDuration:1];
        CCActionSpawn* spawn = [[CCActionSpawn alloc] initOne:scale two:fade];
        [tooShortError runAction:spawn];
        
        login = nil;
    }
        NSLog(@"!E4.1");
        [okButton2 setTarget:self selector:@selector(goPrevius:)];
        okButton2.scale = 0.1;
        [self addChild:okButton2 z:5];
        
        CCActionScaleTo *scale = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
        CCActionFadeIn *fade = [[CCActionFadeIn alloc] initWithDuration:1];
        CCActionSpawn* spawn = [[CCActionSpawn alloc] initOne:scale two:fade];
        [okButton2 runAction:spawn];
    
    }
    else
    {
        
        NSArray* kirilica = [NSArray arrayWithObjects:@"й",@"ц",@"у",@"к",@"е",@"н",@"г",@"ш",@"щ",@"з",@"х",@"ъ",@"ё",
                             @"ф",@"ы",@"в",@"а",@"п",@"р",@"о",@"л",@"д",@"ж",@"э"
                             ,@"я",@"ч",@"с",@"м",@"и",@"т",@"ь",@"б",@"ю",@"/", nil];
        NSString* a = [[NSString alloc] init];
        BOOL kirilicaSymbolPresent = NO;
        int i = 0;
        while (i < [login length])
        {
        a = [login substringWithRange:NSMakeRange(i, 1)];
            for (int j = 0 ;j < kirilica.count ; j++) {
                if ([a isEqualToString:[kirilica objectAtIndex:j]])
                {
                    kirilicaSymbolPresent = YES;
                    break;
                }
            }
        i++;
        }
        
        if (kirilicaSymbolPresent)
        {
            
            errorOfRequiredSymbols = [CCLabelTTF labelWithString:@"Please, enter login in english" fontName:@"AppleGothic" fontSize:14];
            errorOfRequiredSymbols.color = [CCColor redColor];
            errorOfRequiredSymbols.position = ccp(size.width/2, size.height*9/10);
            errorOfRequiredSymbols.scale =0.1;
            [self addChild:errorOfRequiredSymbols];
            
            CCActionScaleTo *scale = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
            CCActionFadeIn *fade = [[CCActionFadeIn alloc] initWithDuration:1];
            CCActionSpawn* spawn = [[CCActionSpawn alloc] initOne:scale two:fade];
            [errorOfRequiredSymbols runAction:spawn];
            login = nil;
            
            [okButton2 setTarget:self selector:@selector(goPrevius:)];
            okButton2.scale = 0.1;
            [self addChild:okButton2 z:5];
            
            CCActionScaleTo *scale2 = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
            CCActionFadeIn *fade2 = [[CCActionFadeIn alloc] initWithDuration:1];
            CCActionSpawn* spawn2 = [[CCActionSpawn alloc] initOne:scale2 two:fade2];
            [okButton2 runAction:spawn2];
            
        }
        else
    [self sendLoginToServer:login];
    }
}
//если логин не подходит, возвращаемся обратно к вводу логина
-(void)goPrevius:(id)sender{
    NSLog(@"!E5");
    [errorLogin setVisible:NO];
    [text1 setVisible:NO];
    [create setVisible:NO];
    [tooShortError setVisible:NO];
    [okButton setVisible:NO];

    [text2 setVisible:NO];
    [errorOfRequiredSymbols setVisible:NO];

    [okButton2 setVisible:NO];
    [field removeFromSuperview];
    [okButton3 setVisible:NO];
    NSLog(@"!E6");

    [self openWindowToCreateLogin];
}	

//отправка логина на сервер
-(void)sendLoginToServer:(NSString*)login{
    
    float bestScore = [SafeScoreClass showTheBestScore];
    NSLog(@"score %f", bestScore);
    NSString* cop = [NSString stringWithFormat:@"%f", bestScore];
    //метка регистрации для php файла
    NSString* t = @"2";
    NSString *post = [[NSString alloc] initWithFormat:@"l=%@&sc=%@&t=%@",login,cop,t];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
 //   NSURL *url = [NSURL URLWithString:@"http://chickens.goldlans.com/index.php"];
    NSURL *url = [NSURL URLWithString:@"http://chickens.goldlans.com/addToDB.php"];

    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    if (connection) {
        NSLog(@"a connected");
     // self.infoData = [NSMutableData data];
    }
    else
    {
        NSLog(@"Connection failed");
    }

    NSURLResponse* responce = [[NSURLResponse alloc] init];
    NSData* getReply = 	[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&responce error:nil];
    NSString* theReply = [[NSString alloc] initWithBytes:[getReply bytes] length:[getReply length] encoding:NSASCIIStringEncoding];
    NSString* shortReply = [theReply substringToIndex:1];
    NSLog(@"%@", shortReply);
    NSString* error2 = @"E";
    if ([shortReply isEqualToString:error2]) {
        NSLog(@"errrroooorr ERROR Request");
    }
    
    NSString* error = @"L";
    if ([shortReply isEqualToString:error]) {
        NSLog(@"errrroooorr Login already exists");
        errorLogin = [CCLabelTTF labelWithString:@"Login already exists. Try another" fontName:@"AppleGothic" fontSize:14];
        errorLogin.color = [CCColor redColor];
        errorLogin.position = ccp(size.width/2, size.height*9/10);
        errorLogin.scale = 0.1;
        [self addChild:errorLogin];
        
        CCActionScaleTo *scale = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
        CCActionFadeIn *fade = [[CCActionFadeIn alloc] initWithDuration:1];
        CCActionSpawn* spawn = [[CCActionSpawn alloc] initOne:scale two:fade];
        [errorLogin runAction:spawn];
        
        login = nil;
        
        okButton3 = [CCButton buttonWithTitle:@"OK" fontName:@"Verdana-Bold" fontSize:14];
        okButton3.positionInPoints = ccp(size.width/2, size.height*6.5/10);
        okButton3.scale = 0.1;
        [okButton3 setTarget:self selector:@selector(goPrevius:)];
        [self addChild:okButton3];
        
        CCActionScaleTo *scale2 = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
        CCActionFadeIn *fade2 = [[CCActionFadeIn alloc] initWithDuration:1];
        CCActionSpawn* spawn2 = [[CCActionSpawn alloc] initOne:scale2 two:fade2];
        [okButton3 runAction:spawn2];
        
    }
    else
    {
        NSLog(@"new login is saved");
        
    //хранит имя пользователя в кєше
    savedLogin = [NSUserDefaults standardUserDefaults];
    [savedLogin setObject:login forKey:@"username"];
    savedBestScore2 = [NSUserDefaults standardUserDefaults];
    [savedBestScore2 setFloat:bestScore forKey:@"bestScore"];

    NSString* showLogin = [NSString stringWithFormat:@"YOUR login is %@",login];
    CCLabelTTF* loginAdded = [CCLabelTTF labelWithString:showLogin fontName:@"AppleGothic" fontSize:14];
    loginAdded.color = [CCColor cyanColor];
    loginAdded.scale = 0.1;
    loginAdded.position = ccp(size.width/2, size.height*9/10);
    [self addChild:loginAdded];
        
        CCActionScaleTo *scale = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
        CCActionFadeIn *fade = [[CCActionFadeIn alloc] initWithDuration:1];
        CCActionSpawn* spawn = [[CCActionSpawn alloc] initOne:scale two:fade];
        [loginAdded runAction:spawn];
        
        [tableView removeFromSuperview];
        tableView = nil;
        [self newTableListCreate];
    }

}

//если у текущего логина есть новый результат, то передать его на сервер.
-(void)verifyNewBestScore{
    float bestScore = [SafeScoreClass showTheBestScore];
    if (bestScore > [[savedBestScore2 objectForKey:@"bestScore"] floatValue]){
        [savedBestScore2 setFloat:bestScore forKey:@"bestScore"];
        NSLog(@"new best score %f", bestScore);
    }
    NSString* cop = [NSString stringWithFormat:@"%f", bestScore];
    //метка входа для php файла
    NSString* t = @"1";
    NSString* l = [[NSString alloc] initWithString:[savedLogin objectForKey:@"username"]];
    NSString* sc = [[NSString alloc] initWithString:cop];
    NSString* newStr = [NSString stringWithFormat:@"l=%@&sc=%@&t=%@", l, sc, t];
    NSLog(@"newStr - %@", [newStr description]);
    NSData *postData = [newStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//    NSURL *url = [NSURL URLWithString:@"http://chickens.goldlans.com/index.php"];
    NSURL *url = [NSURL URLWithString:@"http://chickens.goldlans.com/addToDB.php"];

    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    if (connection) {
        NSLog(@"a connected");
        // self.infoData = [NSMutableData data];
    }
    else
    {
        NSLog(@"Connection failed");
    }
    
    NSURLResponse* responce;
    NSData* getReply = 	[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&responce error:nil];
    NSString* theReply = [[NSString alloc] initWithBytes:[getReply bytes] length:[getReply length] encoding:NSASCIIStringEncoding];
    NSLog(@"!!!%@ reply", theReply);
    if ([theReply isEqualToString:@"WTF error"]){
        NSLog(@"WTF error presenT!");
    }
    NSString* updated = @"data base is updated";
    if ([theReply isEqualToString:updated]){
       CCLabelTTF* textUpdated = [[CCLabelTTF alloc] initWithString:updated fontName:@"Verdana-Bold"  fontSize:16];
        textUpdated.position = ccp(size.width/2, size.height*8/10);
        textUpdated.scale = 0.1;
        [self addChild:textUpdated];
        
        CCActionScaleTo *scale = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
        CCActionFadeIn *fade = [[CCActionFadeIn alloc] initWithDuration:1];
        CCActionSpawn* spawn = [[CCActionSpawn alloc] initOne:scale two:fade];
        [textUpdated runAction:spawn];
        
        NSLog(@"updated");
        
    }
   
}

-(void)showThePositionOf:(NSString*)string{
    NSString* show = [NSString stringWithFormat:@"%@ your position is %@ of %@ players", [arrayOfCurrentPosInTableScore objectAtIndex:0], [arrayOfCurrentPosInTableScore objectAtIndex:1], [arrayOfCurrentPosInTableScore objectAtIndex:2]];
    yourPosition = [CCLabelTTF labelWithString:show fontName:@"AppleGothic"fontSize:10];
    yourPosition.position = ccp(size.width/2, size.height*1.3/10);
    yourPosition.scale = 0.1;
    [yourPosition setVisible:YES];
    [self addChild:yourPosition];
    
    CCActionScaleTo *scale = [[CCActionScaleTo alloc] initWithDuration:0.5 scale:1];
    CCActionFadeIn *fade = [[CCActionFadeIn alloc] initWithDuration:1];
    CCActionSpawn* spawn = [[CCActionSpawn alloc] initOne:scale two:fade];
    [yourPosition runAction:spawn];
}

-(void)goToMainMenu:(id)sender{
    self.recordsCell.hidden = YES;

    [field removeFromSuperview];
    self.listTableView = nil;
   // tableView = nil;
    [tableView removeFromSuperview];
    tableView = nil;

    Class SceneClass = NSClassFromString(@"MenuScene");
    [[CCDirector sharedDirector] replaceScene:[SceneClass scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:1.0f]];

}
@end





