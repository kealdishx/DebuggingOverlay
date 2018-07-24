# DebuggingOverlay

### Purpose

As of iOS 11, Apple has added several checks to ensure that only internal apps that link to UIKit have access to these private debugging classes(such as `UIDebuggingInformationOverlay`).So we use swizzling of runtime to help us access to these private debugging classes.

### Usage

First, drag `DebuggingOverlay.m` under `Sources` folder to your project.

Then, add the code below where you need to call:

**Objective-c**:

```Objectivec
id cls = NSClassFromString(@"DebuggingOverlay");
[cls performSelector:NSSelectorFromString(@"toggleOverlay")];
```

**swift(4.0+)**:

```swift
guard let cls = NSClassFromString("DebuggingOverlay") as? NSObject.Type else {
  return
}

cls.perform(NSSelectorFromString("toggleOverlay"))
```

Finally, it works.