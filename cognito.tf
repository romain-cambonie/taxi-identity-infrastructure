resource "aws_cognito_user_pool" "main" {
  name = "taxi-aymeric-user-pool"

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  username_attributes = ["email", "phone_number"]

  auto_verified_attributes = [/*"phone_number",*/ "email"]

  //  deletion_protection = "INACTIVE"

  // device_configuration {
  //   challenge_required_on_new_device      = true
  //   device_only_remembered_on_user_prompt = false
  // }

  #email_configuration {
  #  email_sending_account = "COGNITO_DEFAULT"
  #}

  email_configuration {
    #email_sending_account = "DEVELOPER"
    #source_arn = "ARN of the SES verified email identity to use."
    configuration_set      = "project_configuration_set"
    from_email_address     = "taxi-gestion Identity Service <identity+noreply@taxi-gestion.com>"
    reply_to_email_address = "taxi-gestion Support Service <support@taxi-gestion.com>"
  }

  //  sms_authentication_message = "Votre code d'authentification est {####}"
  //  sms_verification_message   = "Votre identifiant est {username} et votre code temporaire est {####}"

  tags = local.tags
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "taxi-aymeric-user-pool-app-client"
  user_pool_id = aws_cognito_user_pool.main.id

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "minutes"
  }

  access_token_validity  = 5
  id_token_validity      = 5
  refresh_token_validity = 60

  explicit_auth_flows = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH"]
}

resource "aws_cognito_user_group" "manager" {
  name         = "manager"
  user_pool_id = aws_cognito_user_pool.main.id
}

resource "aws_cognito_user_group" "driver" {
  name         = "driver"
  user_pool_id = aws_cognito_user_pool.main.id
}
