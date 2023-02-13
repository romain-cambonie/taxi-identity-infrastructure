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

  alias_attributes         = ["phone_number", "email"]
  auto_verified_attributes = [/*"phone_number",*/ "email"]

  //  deletion_protection = "INACTIVE"

  device_configuration {
    challenge_required_on_new_device      = true
    device_only_remembered_on_user_prompt = false
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  //  sms_authentication_message = "Votre code d'authentification est {####}"
  //  sms_verification_message   = "Votre identifiant est {username} et votre code temporaire est {####}"

  tags = local.tags
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "taxi-aymeric-user-pool-app-client"
  user_pool_id = aws_cognito_user_pool.main.id

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