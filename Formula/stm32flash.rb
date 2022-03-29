class Stm32flash < Formula
  desc "Open source flash program for STM32 using the ST serial bootloader"
  homepage "https://sourceforge.net/projects/stm32flash/"
  url "https://downloads.sourceforge.net/project/stm32flash/stm32flash-0.7.tar.gz"
  sha256 "c4c9cd8bec79da63b111d15713ef5cc2cd947deca411d35d6e3065e227dc414a"

  livecheck do
    url :stable
    regex(%r{url=.*?/stm32flash[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e65b35e5c13aef89af07d0dfac8aea7b26e940b1dd149db1a9f5a577ef80f56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9835c9d67c457937dacb848a9ab1f75e7ab01d6474dc8c14d88bb25d37171841"
    sha256 cellar: :any_skip_relocation, monterey:       "0cab19a25220c5bf262e3130290d4bede807dff101f832ec912bd4f9a00b1ef5"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe29b3d63844a3249407be1df0837f642c7d4eec039efbca4d6e5974f505ec18"
    sha256 cellar: :any_skip_relocation, catalina:       "a35cb8508eaace5fe7c788ac88d2e11f1a9df9243269901601a563c12473e1c0"
    sha256 cellar: :any_skip_relocation, mojave:         "f66f44494b1f47898d95061c1117f7c9234c6731e7f365badce53768e2c8cfd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfa891293f0366530abbcd9736e30820b4a3b4bb683156ec586859f46c2f8c4e"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/stm32flash -k /dev/tty.XYZ 2>&1", 1)
    assert_match "Failed to open port: /dev/tty.XYZ", output
  end
end
