terraform {
  cloud {
    organization = "terransible-nunu"

    workspaces {
      name = "terransible"
    }
  }
}
