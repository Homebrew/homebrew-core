class TeensyLoaderCli < Formula
  desc "Command-line integration for Teensy USB development boards"
  homepage "https://www.pjrc.com/teensy/loader_cli.html"
  url "https://github.com/PaulStoffregen/teensy_loader_cli/archive/2.1.tar.gz"
  sha256 "5c36fe45b9a3a71ac38848b076cd692bf7ca8826a69941c249daac3a1d95e388"
  license "GPL-3.0-only"
  revision 2
  head "https://github.com/PaulStoffregen/teensy_loader_cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "836285da10f1cc9a44b3c075c03f41ef3720f2edeee2f1cf56ed5622266e0acd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dedc1adc526aa3115e52603b7d69b9177f76fdda51698faf26c1a37d2b648cac"
    sha256 cellar: :any_skip_relocation, monterey:       "01fd3b5973d665f75bec4d1eec914cc11f1f4696ce31d5f45d5e86c59d38d20d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2b86fdf7b04f907b5dbf5e1c31e1488b6de0f681be91acb8779d5d319fa0bbc"
    sha256 cellar: :any_skip_relocation, catalina:       "05c0f806839f8af46bcf6d95bf58247805a5293d4c704d38c2934799b6aa9f1f"
    sha256 cellar: :any_skip_relocation, mojave:         "13a4a0fe8cf9b185003da32206bf330c215a9e0ee99bc4c7a901c474f553e7b1"
    sha256 cellar: :any_skip_relocation, high_sierra:    "58f22f026085148841808fb0a9ec9f5f7558c1ef6fbf46a2ec2a0fea8b9f1c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc204fbd5fcabd5e53f382c899fd97625b1d1f99958b3abc7d9bcb5db687a6c2"
  end

  on_linux do
    depends_on "libusb-compat"
  end

  def install
    if OS.mac?
      ENV["OS"] = "MACOSX"
      ENV["SDK"] = MacOS.sdk_path || "/"

      # Work around "Error opening HID Manager" by disabling HID Manager check. Port of alswl's fix.
      # Ref: https://github.com/alswl/teensy_loader_cli/commit/9c16bb0add3ba847df5509328ad6bd5bc09d9ecd
      # Ref: https://forum.pjrc.com/threads/36546-teensy_loader_cli-on-OSX-quot-Error-opening-HID-Manager-quot
      inreplace "teensy_loader_cli.c", /ret != kIOReturnSuccess/, "0"
    end

    system "make"
    bin.install "teensy_loader_cli"
  end

  test do
    output = shell_output("#{bin}/teensy_loader_cli 2>&1", 1)
    assert_match "Filename must be specified", output
  end
end
