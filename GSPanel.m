#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>

#ifdef XWindowServerKit
#import <XWindowServerKit/XWindow.h>
#endif


@interface MyDelegate : NSObject
{
  NSWindow *myWindow;
}

- (void) createWindow;
- (void) launchXterm: (id)sender;
- (void) applicationWillFinishLaunching: (NSNotification *)not;
- (void) applicationDidFinishLaunching: (NSNotification*)not;

@end

@implementation MyDelegate : NSObject
- (void) dealloc
{
  RELEASE (myWindow);
  [super dealloc];
}

- (void) launchXterm: (id)sender
{
  NSLog(@"Lancement d'un terminal");
}
 

-(void) createWindow
{
  NSRect rect;
  NSRect screenFrame;
  NSSize size;
  NSTextField* label;
  NSImage* logo;
  NSPopUpButton * logoButton;
  NSMenu * buttonMenu;
  NSMenuItemCell * cell;
  NSInteger index;
  NSInteger GSpanelBarHeight;
  
  GSpanelBarHeight=24;

  screenFrame = [[NSScreen mainScreen] frame]; 
  size = NSMakeSize (screenFrame.size.width,screenFrame.size.height);
  NSFont *fontBolded=[NSFont boldSystemFontOfSize:13];
  NSMutableDictionary *attributes ;
  attributes = [NSMutableDictionary new];
  [attributes setObject :fontBolded
		  forKey:NSFontAttributeName];

  NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: @"GNUstep" ];
  [string setAttributes:attributes range:NSMakeRange(0,[string length])];
 

  // Creation of the popup menu

  logo = [[NSImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Logo.tiff" ofType:nil] ];
  logoButton= [[NSPopUpButton alloc] initWithFrame:NSMakeRect(6,0,30,GSpanelBarHeight)];
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

  // Creation of the centered label

  label = [[NSTextField alloc] initWithFrame: NSMakeRect (screenFrame.size.width/2-40,3,40,GSpanelBarHeight-2)];
  [label setSelectable: NO];
  [label setBezeled: NO];
  [label setDrawsBackground: NO];
  [label setAttributedStringValue:string];
  [label sizeToFit];
  [label setAutoresizingMask: NSViewHeightSizable];

  //Creation of the window
  rect = NSMakeRect (0, size.height-GSpanelBarHeight, size.width, GSpanelBarHeight);
  unsigned int styleMask = NSBorderlessWindowMask;
  myWindow = [NSWindow alloc];
  myWindow = [myWindow initWithContentRect: rect
				  styleMask: styleMask
				    backing: NSBackingStoreBuffered
				      defer:NO];
  [myWindow setTitle: @"GSPanel"];
  //  [myWindow setBackgroundColor: topBarColor];
  [myWindow setAlphaValue: 0.9];
  [[myWindow contentView] addSubview: logoButton];
  [myWindow setLevel: NSMainMenuWindowLevel-2];
  [myWindow setCanHide:NO];
  [myWindow setHidesOnDeactivate:NO];
  [[myWindow contentView] addSubview: label];



#ifdef XWindowServerKit
      [myWindow setDesktop: ALL_DESKTOP];
      [myWindow skipTaskbarAndPager];
      //      [myWindow setAsSystemDock];
      [myWindow  reserveScreenAreaOn: XScreenTopSide
			       width: MenuBarHeight
			       start: NSMinX(frame)
				 end: NSMaxX(frame)];

#endif

  [logoButton release];
  [label release];
  [logo release];

  [cell release];

}

- (void) applicationWillFinishLaunching:(NSNotification *)not
{

  [self createWindow];
}

- (void) applicationDidFinishLaunching:(NSNotification *)not
{
  [myWindow orderFront: self];

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
