#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>


@interface MyDelegate : NSObject
{
  NSWindow *topBar;
}

- (NSColor *) backgroundColor;
- (NSColor *) transparentColor;
- (NSInteger) menuBarHeight;
- (void) launchXterm: (id)sender;
- (void) createWindow;
- (void) applicationWillFinishLaunching: (NSNotification *)not;
- (void) applicationDidFinishLaunching: (NSNotification*)not;



@end

@implementation MyDelegate : NSObject
- (void) dealloc
{
  RELEASE (topBar);
  [super dealloc];
}

- (NSColor *) backgroundColor
{
  NSColor *color = [NSColor colorWithCalibratedRed: 0.992 green: 0.992 blue: 0.992 alpha: 0.9];
  return color;
}
- (NSColor *) transparentColor
{
  NSColor *color = [NSColor colorWithCalibratedRed: 0.992 green: 0.992 blue: 0.992 alpha: 0.0];
  return color;
}

- (NSInteger) menuBarHeight
{
  return 24;
}

- (void) launchXterm: (id)sender
{
  NSLog(@"Lancement d'un terminal");
}
 

-(void) createWindow
{
  NSInteger menuBarHeight = [self menuBarHeight];
  NSRect rect;
  NSRect screenFrame;
  NSSize screenSize;
  NSSize stringSize;
  NSColor *color;
  //NSSize logoSize;
  //NSImage* logo=nil;
  //NSPopUpButton * logoButton;
  //NSMenu * buttonMenu;
  NSMenuItemCell * cell=nil;
  NSTextField* label;
  NSFont *menuFont=[NSFont boldSystemFontOfSize:0];
  NSMutableDictionary *attributes ;
  attributes = [NSMutableDictionary new];
  [attributes setObject :menuFont
		  forKey:NSFontAttributeName];
  NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: @"GNUstep" ];
  [string setAttributes:attributes range:NSMakeRange(0,[string length])];
   
   stringSize=[string size];
   

   //printf("stringSize.height : %f \n", stringSize.height);//stringSize.width returns 1 for now. Why ?
 

 
  screenFrame = [[NSScreen mainScreen] frame];
  screenSize = screenFrame.size;
  
  /*
   // Creation of the popup menu

  logo = [[NSImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Logo.tiff" ofType:nil] ];
  logoSize = logo.size;
  logoButton= [[NSPopUpButton alloc] initWithFrame:NSMakeRect(screenSize.width -6-3*logoSize.width,0,3*logoSize.width,menuBarHeight)];
  [logoButton setBezelStyle: NSRegularSquareBezelStyle];
  [logoButton setTitle: @""];
  [logoButton setImage: logo];
  [logoButton setPullsDown: YES];
  [logoButton setBordered: NO];//FixMe : this doesn't work with my popup button.
  buttonMenu =  [logoButton menu];
  NSMenuItem *menuItem = [logoButton itemAtIndex: 0];
 
  [menuItem setImage: logo];

  //cell = [[NSMenuItemCell alloc] init]; 
  //[cell setMenuItem: menuItem];
  //[cell setImagePosition: NSImageLeft];  // FixMe : it seems that popup buttons can't use this to put the image at the left of the title.

  [buttonMenu addItemWithTitle:_(@"Launch xterm")
			action: @selector (launchXterm:)
		 keyEquivalent: @""];
  [buttonMenu addItemWithTitle:_(@"Quit")
			action: @selector (terminate:)
		 keyEquivalent: @"q  "];
  */
  
  // Creation of the label
  label = [[NSTextField alloc] initWithFrame: NSMakeRect (screenSize.width/2-stringSize.width/2,menuBarHeight/2 - stringSize.height/2-1,0,stringSize.height)];
  [label setSelectable: NO];
  [label setBezeled: NO];
  [label setDrawsBackground: NO];
  [label setAttributedStringValue:string];
  [label sizeToFit];
  [label setAutoresizingMask: NSViewHeightSizable];

  
  //Creation of the topBar 
  rect = NSMakeRect (0, screenSize.height-menuBarHeight, screenSize.width, menuBarHeight);
  unsigned int styleMask = NSBorderlessWindowMask;
  topBar = [NSWindow alloc];
  topBar = [topBar initWithContentRect: rect
				  styleMask: styleMask
				    backing: NSBackingStoreBuffered
				      defer:NO];
  [topBar setTitle: @"GSPanel"];
  color = [self backgroundColor];
  [topBar setBackgroundColor:color];
  [topBar setAlphaValue: 1.0];
  [topBar setLevel:NSTornOffMenuWindowLevel-1];
  [topBar setCanHide:NO];
  [topBar setHidesOnDeactivate:NO];


  // Add subviews
  //  [[topBar contentView] addSubview: logoButton];
  [[topBar contentView] addSubview: label];
  // [logoButton release];
  // [logo release];
  [label release];   
  [cell release];

}


- (void) applicationWillFinishLaunching:(NSNotification *)not
{
  [self createWindow];
}

- (void) applicationDidFinishLaunching:(NSNotification *)not
{
  [topBar orderFront: self];
}

@end

int main (int argc, const char * argv[])
{
  NSAutoreleasePool *pool;

  pool = [NSAutoreleasePool new];
  [NSApplication sharedApplication];
  [NSApp setDelegate: [MyDelegate new]];

  [pool drain];
  return NSApplicationMain (argc, argv);
}
