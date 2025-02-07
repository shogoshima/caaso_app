import 'package:caaso_app/models/models.dart';

Function getPrices = (UserType userType) {
  return (PlanType planType) {
    return {
      UserType.aloja: {
        PlanType.monthly: 2.0,
        PlanType.yearly: 20.0,
      },
      UserType.grad: {
        PlanType.monthly: 4.0,
        PlanType.yearly: 40.0,
      },
      UserType.postgrad: {
        PlanType.monthly: 5.0,
        PlanType.yearly: 50.0,
      },
      UserType.other: {
        PlanType.monthly: 6.0,
        PlanType.yearly: 60.0,
      }
    }[userType]?[planType];
  };
};
