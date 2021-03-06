//
//  GameLevelLayer.mm
//  iPointball2D
//
//  Created by Ryan Frahm on 4/6/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//
// Notes on removing bodies
// http://www.iforce2d.net/b2dtut/removing-bodies

#import "GameLevelLayer.h"
#import "GameOverLayer.h"
#import "CCPhysicsSprite.h"
#import "Player.h"

enum {
    kTagParentNode = 1,
};

enum CATEGORY_BITS
{
    PLAYER_CATEGORY_BITS = 0x0001,
    ENEMY_CATEGORY_BITS = 0x0002,
    PAINT_CATEGORY_BITS = 0x0004,
    WORLD_CATEGORY_BITS = 0x0008,
};

enum MASK_BITS
{
    PLAYER_MASK = ENEMY_CATEGORY_BITS | PAINT_CATEGORY_BITS,
    ENEMY_MASK = PLAYER_CATEGORY_BITS | PAINT_CATEGORY_BITS,
    WORLD_MASK = -1,
};

#pragma mark - GameLevelLayer

#define PAINTFPS 680 // pixels/sec
#define PTM_RATIO 32 // pixels-meters

@interface GameLevelLayer()
-(void) initPhysics;
-(void) addNewPlayerAtPosition:(CGPoint)p;
-(void) addNewEnemyAtPosition:(CGPoint)p;
-(void) createMenu;
@end

@implementation GameLevelLayer

@synthesize cache = _cache, doubleTapRecognizer = _doubleTapRecognizer;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLevelLayer *layer = [GameLevelLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}



-(id) init{
    if (self = [super initWithColor:ccc4(255,255,255,255)]) {
        
        // enable events
        
        self.touchEnabled = YES;
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        // init physics
        [self initPhysics];
        
        _paint = [[NSMutableArray alloc]init];
        _enemiesAlive = [[NSMutableArray alloc]init];
        _bunkers = [[NSMutableArray alloc]init];
        // create menu
        // [self createMenu];
        
        // set up sprite
        //self.doubleTapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)] autorelease];
        //_doubleTapRecognizer.numberOfTapsRequired = 2;
        //[[[CCDirector sharedDirector] view] addGestureRecognizer:_doubleTapRecognizer];
        
/*#if 1
        // Batch node. Faster
        CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"player.png" capacity:100];
        spriteTexture_ = [parent texture];
#else
        // doesn't use batch node. Slower
        spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"player.png"];
        CCNode *parent = [CCNode node];
#endif
        [self addChild:parent z:0 tag:kTagParentNode];*/
        
        [self addNewPlayerAtPosition:ccp(1.5*PTM_RATIO, winSize.height/2)];
        [self addNewEnemyAtPosition:ccp(winSize.width -1.5*PTM_RATIO, winSize.height/2)];
        [self addBunkerAtPosition:ccp(winSize.width/2, winSize.height/2)];
        //[self addNewEnemyAtPosition:ccp(470, winSize.height/2)];
        
        [self scheduleUpdate];
        
        //[player setPosition:ccp(player.contentSize.width/2, winSize.height/2)];
        
        // Add bunkers
        
        // collision detection
        contactListener = new MyContactListener();
        world->SetContactListener(contactListener);
    }
    return self;
}

-(void)draw{
    [super draw];
    
    if(firing)
    {
        glLineWidth(3);
        ccDrawColor4F(0.0f, 1.0f, 0.0f, 1.0f);
        //ccDrawCircle( origin, 100, 0, 10, NO);
        ccDrawCircle(origin, 20, 0, 10, NO);
    }
    firing = NO;
    
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position);
    
    kmGLPushMatrix();
    world->DrawDebugData();
    
    kmGLPushMatrix();
}

#pragma mark Physics Bodies

-(void) initPhysics{
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    b2Vec2 gravity;
    gravity.Set(0.0f, 0.0f);
    world = new b2World(gravity);
    
    // Do we want to let bodies sleep?
    world->SetAllowSleeping(true);
    
    world->SetContinuousPhysics(true);
    
    _debugDraw = new GLESDebugDraw(PTM_RATIO);
    world->SetDebugDraw(_debugDraw);
    
    uint32 flags = 0;
    flags += b2Draw::e_shapeBit;
    //		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	_debugDraw->SetFlags(flags);
    
    // Define the ground body.
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0); // bottom-left corner
    //groundBodyDef.angularDamping = 0.1f;
    
    // Call the body factory which allocates memory for the ground body
    // from a pool that creates the ground box shape (also from a pool).
    // The body is also added to the world.
    groundBody = world->CreateBody(&groundBodyDef);
    
    // Define the ground box shape.
    b2EdgeShape groundBox;
    b2FixtureDef groundFixtureDef;
    groundFixtureDef.friction = 0.3f;
    //groundFixtureDef.filter.maskBits = WORLD_CATEGORY_BITS;
    
    
    // bottom
    groundBox.Set(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // top
    groundBox.Set(b2Vec2(0,winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO,winSize.height/PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    
    // left
    groundBox.Set(b2Vec2(0,winSize.height/PTM_RATIO), b2Vec2(0,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // right
    groundBox.Set(b2Vec2(winSize.width/PTM_RATIO,winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    
    groundFixtureDef.shape = &groundBox;
    groundFixtureDef.filter.categoryBits = 0x0001;
}

-(void) addNewPlayerAtPosition:(CGPoint)p{
    //CCLOG(@"Add player %0.2f x %0.2f",player.position.x/PTM_RATIO,player.position.y/PTM_RATIO);
    
    /*_cache = [[CCArray alloc] initWithCapacity:53];
    
    Sprite *player = [[Player alloc] initWithWorld:world];
    [self addChild:player z:1];
    [player activateCollisions];
    [_cache addObject:player];*/
    
    // Create player and add it to the layer
    player = [CCSprite spriteWithFile:@"Player.png"];
    player.position = p;
    player.tag = 1;
    [self addChild:player];
    
    // Define the dynamic body.
    // Set up a 1m squared box in the physics world
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(player.position.x/PTM_RATIO, player.position.y/PTM_RATIO);
    bodyDef.userData = player;
    bodyDef.angle = 0;
    bodyDef.fixedRotation = true;
    bodyDef.angularDamping = 1000.0f;
    bodyDef.linearDamping = 4.0f;
    playerBody = world->CreateBody(&bodyDef);
    
    // Create player shape
    b2PolygonShape playerShape;
    playerShape.SetAsBox(player.contentSize.width/PTM_RATIO/2, player.contentSize.height/PTM_RATIO/2); // These are mid points for our 1m box
    
    // Create shape definition and add to body
    b2FixtureDef playerFixtureDef;
    playerFixtureDef.shape = &playerShape;
    playerFixtureDef.density = 1000.0f;
    playerFixtureDef.friction = 0.4f;
    playerFixtureDef.restitution = 0.1f;
    playerFixtureDef.filter.categoryBits = 0x0002;
    playerFixtureDef.filter.maskBits = 0x0008 | 0x0001;
    
    
    b2CircleShape playerTouchShape;
    playerTouchShape.m_radius = 1.0f;
    
    b2FixtureDef playerTouchFixtureDef;
    playerTouchFixtureDef.shape = &playerTouchShape;
    playerTouchFixtureDef.density = 1000.0f;
    
    _playerFixture = playerBody->CreateFixture(&playerTouchFixtureDef);
    
    playerBody->CreateFixture(&playerFixtureDef);
    
    
    
    /*
    CCNode *parent = [self getChildByTag:kTagParentNode];
    
    // We have a 64 x 64 sprite sheet with 4 different 32 x 32 images.
    CCPhysicsSprite *sprite = [CCPhysicsSprite spriteWithTexture:spriteTexture_];
    [parent addChild:sprite];
    
    [sprite setPTMRatio:PTM_RATIO];
    [sprite setB2Body:body];
    [sprite setPosition:ccp(p.x,p.y)];*/
    
}

-(void) addNewEnemyAtPosition:(CGPoint)p{
    //CCLOG(@"Add enemy %0.2f x %0.2f", p.x,p.y);
    
    // Create enemy and add it to the layer
    enemy = [CCSprite spriteWithFile:@"Target.png"];
    enemy.position = p;
    enemy.tag = 2;
    [self addChild:enemy];
    
    // Define the dynamic body
    // Set up a box in the physics world
    b2BodyDef enemyBodyDef;
    enemyBodyDef.type = b2_dynamicBody;
    enemyBodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    enemyBodyDef.userData = enemy;
    enemyBodyDef.fixedRotation = true;
    enemyBody = world->CreateBody(&enemyBodyDef);
    
    // Create player shape
    b2PolygonShape enemyShape;
    enemyShape.SetAsBox(enemy.contentSize.width/PTM_RATIO/2, enemy.contentSize.height/PTM_RATIO/2);
    
    // Create shape definition and add to body
    b2FixtureDef enemyFixtureDef;
    enemyFixtureDef.shape = &enemyShape;
    enemyFixtureDef.density = 1000.0f;
    enemyFixtureDef.friction = 0.4f;
    enemyFixtureDef.restitution = 0.1f;
    enemyFixtureDef.filter.categoryBits = 0x0004;
    enemyFixtureDef.filter.maskBits = 0x0008 | 0x0001;
    
    enemyFixture = enemyBody->CreateFixture(&enemyFixtureDef);
    
    [_enemiesAlive addObject:enemy];
}

- (void) addNewMovingPaintToLocation:(CGPoint)p :(CGFloat)shootAngle{
    // Adds a bullet animation from the player or enemy towards p
    //CCLOG(@"Paint is moving towards: %0.2f x %0.2f", p.x,p.y);
    
    b2Body *paintBody;
    int power = 2;
    float x1 = cos(shootAngle);
    float y1 = sin(shootAngle);
    
    // Create paint and add it to the layer
    paint = [CCSprite spriteWithFile:@"Projectile.png"];
    paint.position = player.position;
    paint.tag = 3;
    [self addChild:paint];
    
    // body definition
    b2BodyDef paintBodyDef;
    paintBodyDef.type = b2_dynamicBody;
    paintBodyDef.position.Set(paint.position.x/PTM_RATIO, paint.position.y/PTM_RATIO);
    paintBodyDef.userData = paint;
    paintBodyDef.bullet = true;
    //paintBodyDef.angularDamping = 1.0f;
    paintBody = world->CreateBody(&paintBodyDef);
    
    // shape definiation
    b2CircleShape paintShape;
    paintShape.m_radius = 5.0/PTM_RATIO;
    
    // Create shape definition and add to body
    b2FixtureDef paintFixtureDef;
    paintFixtureDef.shape = &paintShape;
    paintFixtureDef.density = 1.0f;
    paintFixtureDef.friction = 0.5f;
    paintFixtureDef.restitution = .01f;
    paintFixtureDef.filter.categoryBits = 0x0008;
    paintFixtureDef.filter.maskBits = 0x0004 | 0x0001;
    
    //paintShapeDef.friction = 0.0f;
    //paintShapeDef.restitution = 1.0f;
    
    paintFixture = paintBody->CreateFixture(&paintFixtureDef);
    b2Body* b = world->GetBodyList();
    //
    // Shoot the paint
    //
    
    // Using Physics
    // Determine offset between the paint and destination p
    b2Vec2 force = b2Vec2(x1*power,y1*power);
    //paintBody->ApplyForceToCenter(force);
    paintBody->ApplyLinearImpulse(force, paintBody->GetWorldCenter());
    //CCLOG(@"Impulse: %0.2f x %0.2f, Point: %0.2f x %0.2f", impulse.x, impulse.y, p.x, p.y);
    
    [_paint addObject:paint];
}

- (void) addBunkerAtPosition:(CGPoint)p{
    bunker.position = p;
    bunker.tag = 4;
    
    b2BodyDef bunkerBodyDef;
    bunkerBodyDef.type = b2_staticBody;
    bunkerBody = world->CreateBody(&bunkerBodyDef);
    
    b2PolygonShape bunkerShape;
    bunkerShape.SetAsBox(0.1f, 1.0f);
    
    b2FixtureDef bunkerFixtureDef;
    bunkerFixtureDef.shape = &bunkerShape;
    bunkerFixtureDef.density = 1.0f;
    bunkerFixtureDef.restitution = 0.1f;
    
    bunkerFixture = bunkerBody->CreateFixture(&bunkerFixtureDef);
    //[_bunkers addObject:bunker];
}

#pragma mark Touch Interaction

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //CCLOG(@"Touch Began");
    NSArray *touchArray = [touches allObjects];
    
    // only run the following code if there is more than one touch
    if([touchArray count]>0)
    {
        // Choose one of the touches to work with
        UITouch *touch1 = [touchArray objectAtIndex:0];
        CGPoint location = [touch1 locationInView:[touch1 view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        origin = location;
        CGPoint shootVector = ccpSub(location, player.position);
        CGFloat shootAngle = ccpToAngle(shootVector);
        b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
        //CGFloat distance = sqrtf((player.position.x-location.x)*(player.position.x-location.x)+(player.position.y-location.y)*(player.position.y-location.y));
        if (_playerFixture->TestPoint(locationWorld)) {
                b2MouseJointDef md;
                md.bodyA = groundBody;
                md.bodyB = playerBody;
                md.target = locationWorld;
                md.collideConnected = false;
                md.maxForce = 20.0f * playerBody->GetMass();
                _mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
                playerBody->SetAwake(true);
        } else {
                // Shoot Stuff!
                [self addNewMovingPaintToLocation:location :shootAngle];
        }
        firing = YES;
        // Set up initial location of projectile
        // CGSize winSize = [[CCDirector sharedDirector] winSize];
        // Shoot projectile
    }
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //CCLOG(@"Touch Moved");
    if (_mouseJoint == NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location1 = [myTouch locationInView:[myTouch view]];
    location1 = [[CCDirector sharedDirector] convertToGL:location1];
    moveToLocation = b2Vec2(location1.x/PTM_RATIO, location1.y/PTM_RATIO);
    //CGFloat distance = sqrtf((player.position.x-location1.x)*(player.position.x-location1.x)+(player.position.y-location1.y)*(player.position.y-location1.y));
    _mouseJoint->SetTarget(moveToLocation);
}

-(void)handleDoubleTap:(UITapGestureRecognizer*)doubleTapRecognizer
{
    CCLOG(@"Double Tap!");
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[self convertToNodeSpace:[doubleTapRecognizer locationInView:[[CCDirector sharedDirector] view]]]];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    CGPoint sprintVector = ccpSub(player.position, location);
    CGFloat sprintAngle = ccpToAngle(sprintVector);
    b2Vec2 impulse = b2Vec2(cosf(sprintAngle)*10, sinf(sprintAngle)*10);
    //playerBody->ApplyLinearImpulse(impulse, locationWorld);
    playerBody->ApplyForceToCenter(impulse);
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    if (_mouseJoint) {
        world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_mouseJoint){
        world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
        //playerBody->SetLinearVelocity(b2Vec2(0,0));
    }
}

- (void) handleTap:(UITapGestureRecognizer *)sender{
    // Enable double tap gesture recognizer to simulate a slide or something
}


-(void) createMenu{
    
}

-(void) update:(ccTime)dt{
    
    int32 velocityIterations = 10;
    int32 positionIterations = 5;
    
    world->Step(dt, velocityIterations, positionIterations);
    
    // Updata position of the texture for the bodies
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *)b->GetUserData();
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
            sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
    
    b2Vec2 playerPos = b2Vec2(player.position.x,player.position.y);
    if(playerPos == moveToLocation)
    {
        //playerBody->SetLinearVelocity(b2Vec2(0,0));
    }
    else
    {
        
    }
    
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for(pos = contactListener->_contacts.begin(); pos != contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        CCSprite *spriteA, *spriteB;
        b2Body *bodyA, *bodyB;
        
        bodyA = contact.fixtureA->GetBody();
        bodyB = contact.fixtureB->GetBody();
        
        if ((contact.fixtureA == _playerFixture && contact.fixtureB == bunkerFixture) || (contact.fixtureA == bunkerFixture && contact.fixtureB == _playerFixture))
        {
            //CCLOG(@"Player hit the bunker!");
            // Bounce off?
        }
        else if ((contact.fixtureA == enemyFixture && contact.fixtureB == bunkerFixture) || (contact.fixtureA == bunkerFixture && contact.fixtureB == enemyFixture))
        {
            //CCLOG(@"Enemy hit the bunker!");
            // Bounce off?
        }
        else if ((contact.fixtureA == _playerFixture && contact.fixtureB == paintFixture) || (contact.fixtureA == paintFixture && contact.fixtureB == _playerFixture))
        {
            //CCLOG(@"Player got hit by paint!");
            
            // Destroy Paint
            
            // Not sure if destroy player
            // Destroy paint
            //CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
            //[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
        else if ((contact.fixtureA == enemyFixture && contact.fixtureB == paintFixture) || (contact.fixtureA == paintFixture && contact.fixtureB == enemyFixture))
        {
            //CCLOG(@"Enemy got hit by paint!");
            
            //if (bodyB->GetUserData() != NULL) {
            //    CCSprite *sprite = (CCSprite *) bodyB->GetUserData();
            //    [self removeChild:sprite cleanup:YES];
            //    [_paint removeLastObject];
            //    world->DestroyBody(bodyB);
            //}
            
            
            
        }
        CGSize winsize = [[CCDirector sharedDirector]winSize];
        
        if(bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL)
        {
            spriteA = (CCSprite *) bodyA->GetUserData();
            spriteB = (CCSprite *) bodyB->GetUserData();
            //CCLOG(@"User data A:%@ B:%@", spriteA, spriteB);
            // spriteA = player, spriteB = paint
            if(spriteA.tag == 1 && spriteB.tag == 3)
            {
                /*if(std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end())
                {
                    toDestroy.push_back(bodyB);
                }*/
            }
            
            // spriteA = paint, spriteB = player
            else if(spriteA.tag == 3 && spriteB.tag == 1)
            {
                /*if(std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end())
                {
                    toDestroy.push_back(bodyA);
                }*/
            }
            
            // spriteA = enemy, spriteB = paint
            else if(spriteA.tag == 2 && spriteB.tag == 3)
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end())
                {
                    toDestroy.push_back(bodyB);
                }
                /*if(std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end())
                {
                    toDestroy.push_back(bodyA);
                    [_enemiesAlive removeLastObject];
                    // Destroy enemy and paint
                    if ([_enemiesAlive count] == 0) {
                        CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
                        [[CCDirector sharedDirector] replaceScene:gameOverScene];
                    }
                }*/
            }
            
            // spriteA = paint, spriteB = enemy
            else if(spriteA.tag == 3 && spriteB.tag == 2)
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end())
                {
                    toDestroy.push_back(bodyA);
                }
                /*if(std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end())
                {
                    toDestroy.push_back(bodyB);
                    [_enemiesAlive removeLastObject];
                    // Destroy enemy and paint
                    if ([_enemiesAlive count] == 0) {
                        CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
                        [[CCDirector sharedDirector] replaceScene:gameOverScene];
                    }
                }*/
            }
            
            else if(spriteA.tag == 3)
            {
                b2Vec2 speed = playerBody->GetLinearVelocity();
                if(speed.x < 0.3f || speed.y < 0.3f)
                {
                    if(std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end())
                    {
                        toDestroy.push_back(bodyA);
                    }
                }
            }
            
            else if(spriteB.tag == 3)
            {
                b2Vec2 speed = playerBody->GetLinearVelocity();
                if(speed.x < 0.3f || speed.y < 0.3f)
                {
                    if(std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end())
                    {
                        toDestroy.push_back(bodyB);
                    }
                }
            }
            
        }
        else
        {
            //CCLOG(@"User data A:%@ B:%@", spriteA, spriteB);
        }
    }
    
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2)
    {
        b2Body *body = *pos2;
        if(body ->GetUserData() != NULL)
        {
            CCSprite *sprite = (CCSprite *) body->GetUserData();
            [self removeChild:sprite cleanup:YES];
        }
        world->DestroyBody(body);
    }
}

-(void) enemyMoveDecision{
    CCLOG(@"Enemy is thinking..");
    
}

-(void) dealloc{
    delete world;
    world = NULL;
    
    [_doubleTapRecognizer release];
    _doubleTapRecognizer = nil;
    
    delete _debugDraw;
    
    delete contactListener;
    
    [_cache release];
    _cache = nil;
    
    [super dealloc];
}

@end
