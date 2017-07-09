#import "IKCAssembly.h"

@implementation IKCAssembly

- (IKCAppDelegate *)appDelegate {
    return [TyphoonDefinition withClass:[IKCAppDelegate class]];
}

- (IKCCurrencyProvider *)currencyProvider {
    return [TyphoonDefinition withClass:[IKCCurrencyProvider class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (IKCRateProvider *)rateProvider {
    return [TyphoonDefinition withClass:[IKCRateProvider class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (IKCExchangeViewModel *)exchangeViewModel {
    return [TyphoonDefinition withClass:[IKCExchangeViewModel class] configuration:^(TyphoonDefinition *definition) {
        SEL initializerSelector = NSSelectorFromString(@"initWithRateProvider:currencyProvider:");
        [definition useInitializer:initializerSelector parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self rateProvider]];
            [initializer injectParameterWith:[self currencyProvider]];
        }];
    }];
}

- (IKCExchangeController *)exchangeController {
    return [TyphoonDefinition withClass:[IKCExchangeController class] configuration:^(TyphoonDefinition *definition) {
        SEL viewModelSelector = NSSelectorFromString(@"viewModel");
        [definition injectProperty:viewModelSelector with:[self exchangeViewModel]];
    }];
}

@end