class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v2.2.1.tar.gz"
  sha256 "f6ec48009618d678f635e22600a1eac19560de99a62bfded9ad9859208e3fbde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e0021a29df959c39a8e4166f7648a680565123663ccfa1aa0540e4749428ff1a"
    sha256 cellar: :any_skip_relocation, big_sur:       "b69a7f8021f31c5b311f78890619e49724a55e6859a1a2294e021adb45603b28"
    sha256 cellar: :any_skip_relocation, catalina:      "f614cf1e5c272d9e61cd8bfce7861c6920b479b7a1799df2dc646872fa1c7f10"
    sha256 cellar: :any_skip_relocation, mojave:        "1ac8826cc9f1e6202dee1dd786a724d8cf193313fa52ed2e902f46d193c24791"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"uni"
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
