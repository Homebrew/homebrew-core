class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-270.tar.bz2"
  sha256 "6e0fe840ee91430888a08db8ef7739b1884fa43e8b2b5e173e6ae3eda3150291"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dfa57def797736a1be116fdc4a6d56c20b4b85c7c6f0e21155f8f974abcbc1ab"
    sha256 cellar: :any, big_sur:       "f27cee79fa05fa1d97cfcc46a4ad292d3ac58e758be40d9760ec4a90e68b71a2"
    sha256 cellar: :any, catalina:      "3fe0ee8231563baeaa72e3390c63ab87a0b838ce9ad3fb11f1bd0e12f79b9e5d"
    sha256 cellar: :any, mojave:        "411c8b572c3db1bf314ab7e1adaae282ff53d85f4137402cb27ee03e0a983ea1"
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
