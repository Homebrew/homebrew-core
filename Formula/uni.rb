class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v2.5.1.tar.gz"
  sha256 "806fbba66efaa45cd5691efcd8457ba8fe88d3b2f6fd0b027f1e6ef62253d6fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "279b2e82199bd95bf4b83532fdae413b148d56546a76b88f4bc371c972181cfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9bad02bbe068358c07b85f7b4069cc518bd193dc31bf8bd2853ef9b3b612185"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9bad02bbe068358c07b85f7b4069cc518bd193dc31bf8bd2853ef9b3b612185"
    sha256 cellar: :any_skip_relocation, ventura:        "52f454796da0a7896185d0e5bfd9b1cd26d7b38cacd2baa62a88a49e6f3d1e43"
    sha256 cellar: :any_skip_relocation, monterey:       "86d641d3f5fadd4b9bfb08b8791bedcc7e5545a697c2b5bedd2ddb8039e12963"
    sha256 cellar: :any_skip_relocation, big_sur:        "86d641d3f5fadd4b9bfb08b8791bedcc7e5545a697c2b5bedd2ddb8039e12963"
    sha256 cellar: :any_skip_relocation, catalina:       "86d641d3f5fadd4b9bfb08b8791bedcc7e5545a697c2b5bedd2ddb8039e12963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9beb85eb77f2bd8b05bd7f49f049e9633b264da82c0ae09b041dbe56c3a8026"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
