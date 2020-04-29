class TeensyLoaderCli < Formula
  desc "Command-line integration for Teensy USB development boards"
  homepage "https://www.pjrc.com/teensy/loader_cli.html"
  url "https://github.com/PaulStoffregen/teensy_loader_cli/archive/2.1.tar.gz"
  sha256 "5c36fe45b9a3a71ac38848b076cd692bf7ca8826a69941c249daac3a1d95e388"
  revision 2
  head "https://github.com/PaulStoffregen/teensy_loader_cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7f74686ca19b38755cabce80ccbc58610aa4ab41cb2ae092b49fd409095a0b14" => :catalina
    sha256 "29f39b8c7638729e3217e102c3c1baae55e77446cd98f4eb98bd9a03a1af2dcf" => :mojave
    sha256 "27403d4218ade972073291cf3a7c0550bf624fa7ad5ad60d63786ca87303d518" => :high_sierra
    sha256 "8e4375b7d7fef1ed28bb48cef480c347ef488137956a61ec8b146946fd25e324" => :sierra
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
