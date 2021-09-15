class Stm32flash < Formula
  desc "Open source flash program for STM32 using the ST serial bootloader"
  homepage "https://sourceforge.net/projects/stm32flash/"
  url "https://downloads.sourceforge.net/project/stm32flash/stm32flash-0.6.tar.gz"
  sha256 "ee9b40d4d3e5cd28b993e08ae2a2c3c559b6bea8730cd7e1d40727dedb1dda09"

  livecheck do
    url :stable
    regex(%r{url=.*?/stm32flash[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9835c9d67c457937dacb848a9ab1f75e7ab01d6474dc8c14d88bb25d37171841"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe29b3d63844a3249407be1df0837f642c7d4eec039efbca4d6e5974f505ec18"
    sha256 cellar: :any_skip_relocation, catalina:      "a35cb8508eaace5fe7c788ac88d2e11f1a9df9243269901601a563c12473e1c0"
    sha256 cellar: :any_skip_relocation, mojave:        "f66f44494b1f47898d95061c1117f7c9234c6731e7f365badce53768e2c8cfd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfa891293f0366530abbcd9736e30820b4a3b4bb683156ec586859f46c2f8c4e"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/stm32flash -k /dev/tty.XYZ 2>&1", 1)
    assert_match "Failed to open port: /dev/tty.XYZ", output
  end
end
