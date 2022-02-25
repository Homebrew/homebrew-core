class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-274.tar.bz2"
  sha256 "6d6833d2498f2cdd15d2b9054620aac6406384df0557d7cbf95bbc192c3d25ae"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "bdd667913a470691f16f3c852a87637a48f107e81e20b88e493d12d3b73bccd6"
    sha256 cellar: :any, arm64_big_sur:  "17abc8b2fe72184327bbb6db9638093aa91ec757b40c5d99308de7d91acd0eba"
    sha256 cellar: :any, monterey:       "786cb663b29a0ff89185870eaf33e4328b75b3d58f4390878619935e7a87e436"
    sha256 cellar: :any, big_sur:        "38d2106e8658d58ae923ad89154cb98fe4c7ed2b26ed5aa273829082194ebef0"
    sha256 cellar: :any, catalina:       "9d4d18b352e5bb2eb5813824d4880d70703296b18d005d8ac80cd61de48b635e"
  end

  depends_on "libffi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
