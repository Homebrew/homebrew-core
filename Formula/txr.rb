class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-261.tar.bz2"
  sha256 "761ffbcc4162e22d45865e7cbb96ffa5d4b07614f7f8a4c8ae1d937d96942755"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8632af8d626ec40373216ea6910dcceb781afc94857708929de21d10ec27e861"
    sha256 cellar: :any, big_sur:       "a2a27fd666f5f997144bb9e478cc68d54ef3b9dad3f222efea713ebfc74b59fb"
    sha256 cellar: :any, catalina:      "e068094b916a6ae3991db1133adc2fc1390ca0c69ba024d72811d34e5670e120"
    sha256 cellar: :any, mojave:        "0e9832dd927570dd352be6847e115046f5c185cd392454333829ce0e95235d46"
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
