abstract class SocialRegisterStates {}

class SocialRegisterInitialState extends SocialRegisterStates {}

class SocialRegisterLoadingState extends SocialRegisterStates {}

class SocialRegisterSuccessState extends SocialRegisterStates {}

class SocialRegisterErrorState extends SocialRegisterStates {
  final String error;

  SocialRegisterErrorState(this.error);
}

class SocialCreatUserSuccessState extends SocialRegisterStates {
  final uId;

  SocialCreatUserSuccessState(this.uId);
}

class SocialCreatUserErrorState extends SocialRegisterStates {
  final String error;

  SocialCreatUserErrorState(this.error);
}

class SocialRegisterChangePasswordVisibilityState extends SocialRegisterStates {
}
