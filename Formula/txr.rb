class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-254.tar.bz2"
  sha256 "981e6f0ac4ac4c9c6157be5899c1af3751a20b4ceed81c95f61beece82d87f7e"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "4489fe06875895d743331871228d3a59f5407684473256eb0a37d55e650fde56"
    sha256 cellar: :any, catalina: "e3a27f84f02b756a98377bba1ac26733cf727968bd222cda4443abb97f3c7df7"
    sha256 cellar: :any, mojave:   "b27fd73874b460ceb4957dcc498d89aa7f0132cd697e8f26eb51da38e6386cda"
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
