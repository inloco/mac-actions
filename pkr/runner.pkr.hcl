variable "actions-version" {
  type    =  string
  default = "2.298.2"
}

variable "brew-version" {
  type    =  string
  default = "HEAD"
}

variable "xcode-version" {
  type    =  string
  default = "13.4.1"
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
      "curl -Lfo /private/tmp/brew.sh https://github.com/Homebrew/install/raw/${var.brew-version}/install.sh",
      "chmod +x /private/tmp/brew.sh",
      "HOMEBREW_INSTALL_FROM_API=1 /private/tmp/brew.sh",
      "rm -Rfv /private/tmp/brew.sh",

      "HOMEBREW_INSTALL_FROM_API=1 brew install --formula jq mas skopeo xcinfo",
      "HOMEBREW_INSTALL_FROM_API=1 brew install --cask intel-haxm",

      # "mas install 497799835",
      # "xcinfo install ${var.xcode-version}",
      "skopeo copy --debug --command-timeout 1h docker://docker.io/inloco/xcode:${var.xcode-version} dir:///private/tmp/Xcode.dir",
      "tar -zxvf /private/tmp/Xcode.dir/$(jq -r '.layers[0].digest | split(\":\")[-1]' /private/tmp/Xcode.dir/manifest.json) -C /private/tmp",
      "cd /Applications && xip -x /private/tmp/Xcode.xip",
      "rm -Rfv /private/tmp/Xcode.*",
      "sudo xcode-select -s /Applications/Xcode.app",
      "sudo xcodebuild -license accept",

      "sudo mkdir -p /opt/actions-runner",
      "sudo chown 501:20 /opt/actions-runner",
      "curl -Lfo /private/tmp/actions-runner.tgz https://github.com/actions/runner/releases/download/v${var.actions-version}/actions-runner-osx-x64-${var.actions-version}.tar.gz",
      "tar -zxvf /private/tmp/actions-runner.tgz -C /opt/actions-runner",
      "rm -Rfv /private/tmp/actions-runner.tgz",
    ]
  }
}
