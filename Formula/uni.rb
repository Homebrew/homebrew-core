class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v2.5.1.tar.gz"
  sha256 "806fbba66efaa45cd5691efcd8457ba8fe88d3b2f6fd0b027f1e6ef62253d6fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84c7d34fcb7282ee83755530db6e2a95cfbcfe9e532471a40662626c2306357d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eec5604de6223abf296f5816ef9ce9c301e5afb807ff9311ee4ce6ae1b14f7b3"
    sha256 cellar: :any_skip_relocation, monterey:       "3353fdff0ae506db6db053cd822a41d42c925a2b4095c25e30fa1ec0654e87b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d7850c4eea36c669444b2e97c3a7de6fcb3ddf15be0fc2a71b27639c89799db"
    sha256 cellar: :any_skip_relocation, catalina:       "d53c6fdadf9b1b19b705db1462343bf298c3870718427baecffbfff7453a3776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f375e073263ce56706c096ebe8ad3c13aee597f4a7ee752538d7e047a9eaac9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
