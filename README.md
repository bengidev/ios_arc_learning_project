# iOS ARC Learning Project

A hands-on learning project for understanding **Automatic Reference Counting (ARC)** memory management in Objective-C, introduced with iOS 5.

> 💡 **Educational Purpose**: This project demonstrates modern ARC patterns. Compare with the [MRR Learning Project](https://github.com/bengidev/ios_mrr_learning_project) to understand the evolution.

## 📚 What You'll Learn

### ARC Fundamentals
- **Automatic retain/release**: Compiler inserts memory management calls
- **Strong references**: Default ownership (replaces `retain`)
- **Weak references**: Non-owning, auto-nils when deallocated
- **Retain cycles**: How to identify and prevent them

### Property Attributes
| ARC Attribute | Purpose |
|---------------|---------|
| `strong` | Object ownership (default) |
| `weak` | Non-owning, becomes nil automatically |
| `copy` | Create owned copy |
| `assign` | Primitives only |
| `unsafe_unretained` | Like weak without auto-nil (rare) |

### Key Differences from MRR
| Aspect | MRR (Manual) | ARC (Automatic) |
|--------|--------------|-----------------|
| Memory calls | Manual `retain`/`release` | Compiler-inserted |
| Dealloc | Required for cleanup | Usually not needed |
| Weak refs | `assign` (dangerous) | `weak` (safe, auto-nil) |
| Blocks | Complex memory rules | `__weak` capture |

## 🛠 Project Setup

### Requirements
- Xcode 15+ (or latest version)
- macOS Sonoma or later
- iOS Simulator

### Building
1. Open `ARC Project.xcodeproj` in Xcode
2. Select iOS Simulator target
3. Build and Run (⌘R)

### ARC is Enabled
This project uses **Objective-C Automatic Reference Counting** (default in modern Xcode).

## 📖 Code Examples

### Property Declaration (ARC)
```objc
@interface Person : NSObject
@property (nonatomic, strong) NSString *name;     // Owns this
@property (nonatomic, weak) id<PersonDelegate> delegate;  // Safe weak ref
@property (nonatomic, copy) NSString *bio;        // Owns a copy
@property (nonatomic, assign) NSInteger age;      // Primitive
@end

@implementation Person
// No dealloc needed for most cases!
// ARC automatically releases properties
@end
```

### Avoiding Retain Cycles
```objc
// In blocks - use __weak
__weak typeof(self) weakSelf = self;
self.completionHandler = ^{
    [weakSelf doSomething];  // Safe! No retain cycle
};
```

### Dealloc (Only for Non-Memory Cleanup)
```objc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // NO [super dealloc] in ARC!
    // NO releasing of properties - ARC handles it
}
```

## 📁 Project Structure

```
ARC Project/
├── AppDelegate.h/m      # Application lifecycle
├── ViewController.h/m   # Main view controller
├── Models/              # Data models with ARC
├── Services/            # Service classes with delegates
└── Supporting Files/    # Resources and configuration
```

## 🔍 ARC Memory Management Rules

### The Simplified Rules
1. Use `strong` for objects you own
2. Use `weak` for delegates and parent references
3. Use `copy` for immutable value types (NSString, blocks)
4. Watch for retain cycles in blocks → use `__weak`

### Common Pitfalls
- ❌ Strong reference cycles between objects
- ❌ Forgetting `__weak` in block captures
- ❌ Using `strong` for delegates
- ✅ Use Instruments to detect leaks

## 📝 License

This project is for educational purposes. Feel free to use and modify for learning.

## 🙏 Acknowledgments

- Apple's ARC documentation
- Compare with [MRR Learning Project](https://github.com/bengidev/ios_mrr_learning_project)
