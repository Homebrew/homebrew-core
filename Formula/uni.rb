class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v2.2.1.tar.gz"
  sha256 "f6ec48009618d678f635e22600a1eac19560de99a62bfded9ad9859208e3fbde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c206aa381509410a5ec09b211a2525cf5460a382c459cb73997e9f695c98b1a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c17f77e18edbc5a7b25bb18978ed2615f2072e5c194b9eadc723979c6219ee9"
    sha256 cellar: :any_skip_relocation, catalina:      "c839b0b932d6440cf5877e532276a7276b0b5c4921e3429a15d8cf6e059022d7"
    sha256 cellar: :any_skip_relocation, mojave:        "31ff8bd67b8413298a8eb08a83ec35e9d17930fefbdbca090911970e64c065c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddff8f6996cdd636995a6492d42a6c6e6181a39337e8d1dd2c4044ab88d317dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"uni"
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
