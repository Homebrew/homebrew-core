class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-252.tar.bz2"
  sha256 "ddd9c05c16fa4afc349a9ce8ffa89418f4cf956c57b44668dd50377b1810e763"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "2fa0534cc68e203e7c790462d5a533c275ba39f5230b02bf8791d8d433218603"
    sha256 cellar: :any, catalina: "8410a6fe27a0f2571917be38326bd3b7d8a8139515b6b2490f8dfc783743246b"
    sha256 cellar: :any, mojave:   "c9d4e8eacef29bd64f45f6f59fc2bcfb17947b5c2f293315077cc575d7f69de5"
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
