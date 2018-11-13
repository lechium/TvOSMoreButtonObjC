# TvOSMoreButtonObjC
Objetive-C port of https://github.com/cgoldsby/TvOSMoreButton

I've noticed issues getting the localized strings to work when I use this as a framework in nitoTV but it works fine in the provided SampleApp target. Theres a known "bug" there of some sort, but I'm not sure what it is yet.

If this port becomes popular I will make it into a cocoapod and debug why some localizaton issues arent working.

Some of the AutoLayout code was inspired by PureLayout, a great obj-c helper library. I also took some ideas of SVProgressHUD re: KVO. Not that it was needed but made for some easier copy pasta.

The swift project this is based on took inspiration from a blog post that appears to be gone, but the author of said post (Mona Zhang) still has NSString+Truncate up on their github https://github.com/mona-zsh/EMTruncation, upon which the swift version was clearly inspired. I took and updated this category to support some of the additional features supplied in said swift project. Still a WIP.

This project can also be a good demonstration of how certain things work differently in Objective-C and Swift. For instance swift has didSet whereas Objective-C would either need to implement custom getters and setters OR do some KVO work to monitor variables they change and update the UI accordingly. I did a bit more of a stripped down version of this so there didnt need to be a bunch of additional logic on every single property change. In addition there is a setupDefaults command that replicates functionality that is available in Swift but not Obj-c. Lastly I left out the localization extension for [NS]String because between the enums and the emojis it also implemented features not available in Objective-C.
