plugin "terraform" {
    enabled = true
    preset  = "all"
}
plugin "azurerm" {
    enabled = true
    version = "0.21.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
