asi-http-request
================

Easy to use CFNetwork wrapper for HTTP requests, Objective-C,  Mac OS X and iPhone (Framework version)


================
How it's work?
================

If you don't need change anything in ASIHTTPRequest library: 
Simply take ODASIHTTPRequest.framework (iOs version) in /build/Products/Release-iphoneuniversal

If not, launch ODASIHTTPRequest project, do change, and rebuild framework.

Dependency are not in .framework, when you use ODASIHTTPRequest.framework in your project, don't forget import CFNetwork, SystemConfiguration, MobileCoreServices, CoreGraphics and zlib.
