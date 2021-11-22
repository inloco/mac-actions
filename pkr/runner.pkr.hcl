variable "actions-version" {
  type    =  string
  default = "2.284.0"
}

variable "brew-version" {
  type    =  string
  default = "HEAD"
}

variable "xcode-version" {
  type    =  string
  default = "13.1"
}

source "vagrant" "runner" {
  communicator = "ssh"
  source_path = "incognia/macbox"
  provider = "vmware_fusion"
}

build {
  name = "runner"

  sources = [
    "sources.vagrant.runner",
  ]

  provisioner "shell" {
    inline = [
      "curl -fLo /private/tmp/brew.sh https://raw.githubusercontent.com/Homebrew/install/${var.brew-version}/install.sh",
      "chmod +x /private/tmp/brew.sh",
      "/private/tmp/brew.sh",
      "rm -f /private/tmp/brew.sh",

      # "brew install --formula mas",
      # "mas install 497799835",
      # "brew install --formula xcinfo",
      # "xcinfo install ${var.xcode-version}",
      "curl -fLo /private/tmp/Xcode.xip https://macbox.s3.amazonaws.com/Xcode_${var.xcode-version}.xip",
      "cd /Applications && xip -x /private/tmp/Xcode.xip",
      "rm -f /private/tmp/Xcode.xip",
      "sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer",
      "sudo xcodebuild -license accept",

      "brew install --cask android-commandlinetools android-platform-tools intel-haxm temurin",
      "yes | sdkmanager --licenses",

      "sudo mkdir -p /opt/actions-runner",
      "sudo chown 501:20 /opt/actions-runner",
      "curl -fLo /private/tmp/actions-runner.tgz https://github.com/actions/runner/releases/download/v${var.actions-version}/actions-runner-osx-x64-${var.actions-version}.tar.gz",
      "tar -zxvf /private/tmp/actions-runner.tgz -C /opt/actions-runner",
      "rm -f /private/tmp/actions-runner.tgz",
    ]
  }
}
