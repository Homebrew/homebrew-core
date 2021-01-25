class TeensyLoaderCli < Formula
  desc "Command-line integration for Teensy USB development boards"
  homepage "https://www.pjrc.com/teensy/loader_cli.html"
  url "https://github.com/PaulStoffregen/teensy_loader_cli/archive/2.1.tar.gz"
  sha256 "5c36fe45b9a3a71ac38848b076cd692bf7ca8826a69941c249daac3a1d95e388"
  license "GPL-3.0"
  revision 2
  head "https://github.com/PaulStoffregen/teensy_loader_cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2b86fdf7b04f907b5dbf5e1c31e1488b6de0f681be91acb8779d5d319fa0bbc" => :big_sur
    sha256 "dedc1adc526aa3115e52603b7d69b9177f76fdda51698faf26c1a37d2b648cac" => :arm64_big_sur
    sha256 "05c0f806839f8af46bcf6d95bf58247805a5293d4c704d38c2934799b6aa9f1f" => :catalina
    sha256 "13a4a0fe8cf9b185003da32206bf330c215a9e0ee99bc4c7a901c474f553e7b1" => :mojave
    sha256 "58f22f026085148841808fb0a9ec9f5f7558c1ef6fbf46a2ec2a0fea8b9f1c18" => :high_sierra
  end

  def install
    ENV["OS"] = "MACOSX"
    ENV["SDK"] = MacOS.sdk_path || "/"

    inreplace "teensy_loader_cli.c", /ret != kIOReturnSuccess/, "0"

    system "make"
    bin.install "teensy_loader_cli"
  end

  test do
    output = shell_output("#{bin}/teensy_loader_cli 2>&1", 1)
    assert_match /Filename must be specified/, output
  end
end
