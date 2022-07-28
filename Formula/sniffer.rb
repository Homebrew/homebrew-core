class Sniffer < Formula
  desc "Modern alternative network traffic sniffer"
  homepage "https://github.com/chenjiandongx/sniffer"
  url "https://github.com/chenjiandongx/sniffer/archive/v0.6.1.tar.gz"
  sha256 "130d588c2472939fc80e3c017a1cae4d515770f1bcab263d985e3be1498d2dbc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "616c6339cae6e6440e3f0665eb19d75fcb1f4ffa8512332b5b21b99f2d58c15e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e8c25962d47038ff3397b6c3e9a43d068b4ada3dc2d6a74edd4694bfb570c9e"
    sha256 cellar: :any_skip_relocation, monterey:       "69c2d55b41d8a6be60ca7926bfee1fb26c6ca731d4e686b55398c3e064a83e01"
    sha256 cellar: :any_skip_relocation, big_sur:        "161cf99bfb9acbdba01eb3e92ec443340631aef80b387c5189650c5b882523f3"
    sha256 cellar: :any_skip_relocation, catalina:       "592beebb4a380730e58cdcd33f306bb75b113108dca42405b96feab0d67345a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eb37ea9f4b54aea4452ef17509a373dfff54b1c0356fc68a8b2a4f3f934396c"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "lo", shell_output("#{bin}/sniffer -l")
  end
end
