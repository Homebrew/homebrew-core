class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-253.tar.bz2"
  sha256 "814624485b389fe08282e7bc8b6cdc77a6e6fd804f1a809a6db8f0e3e61cf631"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "2a03fbb8034d38420e0a5d843feba842cd3b3587aba842ec6288b46fb29a9bab"
    sha256 cellar: :any, catalina: "2685268c69f4fb8e0742c2c5facd02fc1e3eab4b2536a16a4d038a84dfb6a493"
    sha256 cellar: :any, mojave:   "b1e1396f67f33235c765a7f34b3c0da4acaef697f266ceab90b9f4cbd2d125f2"
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
