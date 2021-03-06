#import "VENCalculatorInputTextField.h"
#import "VENMoneyCalculator.h"
#import "UITextField+VENCalculatorInputView.h"

@interface VENCalculatorInputTextField ()
@property (strong, nonatomic) VENMoneyCalculator *moneyCalculator;
@end

@implementation VENCalculatorInputTextField

- (instancetype)initWithFrame:(CGRect)frame keyboardStyle:(VENCalculatorInputViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpInitWithStyle:style];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpInitWithStyle:VENCalculatorInputViewStyleDefault];
    }
    return self;
}

- (void)awakeFromNib {
    // style can with value from runtime attribute in Interface Builder
    [self setUpInitWithStyle:self.style];
}

- (void)setUpInitWithStyle:(VENCalculatorInputViewStyle)style {
    self.locale = [NSLocale autoupdatingCurrentLocale];
    self.style = style;

    VENCalculatorInputView *inputView = [[VENCalculatorInputView alloc] initWithStyle:style];
    inputView.delegate = self;
    inputView.locale = self.locale;
    self.inputView = inputView;

    VENMoneyCalculator *moneyCalculator = [VENMoneyCalculator new];
    moneyCalculator.locale = self.locale;
    self.moneyCalculator = moneyCalculator;

    [self addTarget:self action:@selector(venCalculatorTextFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(venCalculatorTextFieldDidEndEditing) forControlEvents:UIControlEventEditingDidEnd];
}


#pragma mark - Properties

- (void)setLocale:(NSLocale *)locale {
    _locale = locale;
    VENCalculatorInputView *inputView = (VENCalculatorInputView *)self.inputView;
    inputView.locale = locale;
    self.moneyCalculator.locale = locale;
}


#pragma mark - UITextField

- (void)venCalculatorTextFieldDidChange {
    if (![self.text length]) return;

    NSString *lastCharacterString = [self.text substringFromIndex:[self.text length] - 1];
    NSString *subString = [self.text substringToIndex:self.text.length - 1];
    if ([lastCharacterString isEqualToString:@"+"] ||
        [lastCharacterString isEqualToString:@"−"] ||
        [lastCharacterString isEqualToString:@"×"] ||
        [lastCharacterString isEqualToString:@"÷"]) {
        NSString *evaluatedString = [self.moneyCalculator evaluateExpression:subString];
        if (evaluatedString) {
            self.text = [NSString stringWithFormat:@"%@%@", evaluatedString, lastCharacterString];
        } else {
            self.text = subString;
        }
    } else if ([lastCharacterString isEqualToString:[self decimalSeparator]]) {
        if(![self isDecimalValid])
        {
            self.text = subString;
        }
    }
}

-(BOOL)isDecimalValid
{
    NSString *subString = [self.text substringToIndex:self.text.length - 1];
    NSArray* components = [subString componentsSeparatedByCharactersInSet:[self separaterSet]];
    NSString* lastComponent = [components lastObject];
    return ![lastComponent containsString:[self decimalSeparator]];
}

-(NSCharacterSet*)separaterSet
{
    NSMutableCharacterSet* set = [[NSCharacterSet characterSetWithCharactersInString:@"."] mutableCopy];
    [set formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    return [set invertedSet];
}

- (void)venCalculatorTextFieldDidEndEditing {
    NSString *textToEvaluate = [self trimExpressionString:self.text];
    NSString *evaluatedString = [self.moneyCalculator evaluateExpression:textToEvaluate];
    if (evaluatedString) {
        self.text = evaluatedString;
    }
}


#pragma mark - VENCalculatorInputViewDelegate

- (void)calculatorInputView:(VENCalculatorInputView *)inputView didTapKey:(NSString *)key {
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        NSRange range = [self selectedNSRange];
        if ([self.delegate textField:self shouldChangeCharactersInRange:range replacementString:key]) {
            [self insertText:key];
        }
    } else {
        [self insertText:key];
    }
}

- (void)calculatorInputViewDidTapBackspace:(VENCalculatorInputView *)calculatorInputView {
    [self deleteBackward];
}

- (void)calculatorInputViewDidTapEquals:(VENCalculatorInputView *)calculatorInputView {
    [self venCalculatorTextFieldDidEndEditing];
    [self endEditing:YES];
}

- (void)calculatorInputViewDidTapChangeSign:(VENCalculatorInputView *)calculatorInputView {
    NSString *textToEvaluate = [self trimExpressionString:self.text];
    NSString *evaluatedString = [self.moneyCalculator evaluateExpression:textToEvaluate];
    if (evaluatedString) {
        NSString *firstCharacter = [self.text substringToIndex:1];
        if ([firstCharacter isEqualToString:@"-"] || [firstCharacter isEqualToString:@"−"]) {
            self.text = [self.text substringFromIndex:1];
        }
        else {
            self.text = [NSString stringWithFormat:@"-%@", evaluatedString];
        }
    }
}


#pragma mark - Helpers

/**
 Removes any trailing operations and decimals.
 @param expressionString The expression string to trim
 @return The trimmed expression string
 */
- (NSString *)trimExpressionString:(NSString *)expressionString {
    if ([self.text length] > 0) {
        NSString *lastCharacterString = [self.text substringFromIndex:[self.text length] - 1];
        if ([lastCharacterString isEqualToString:@"+"] ||
            [lastCharacterString isEqualToString:@"−"] ||
            [lastCharacterString isEqualToString:@"×"] ||
            [lastCharacterString isEqualToString:@"÷"]) {
            return [self.text substringToIndex:self.text.length - 1];
        }
    }
    return expressionString;
}

- (NSString *)decimalSeparator {
    return [self.locale objectForKey:NSLocaleDecimalSeparator];
}

@end
