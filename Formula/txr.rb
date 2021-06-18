class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-262.tar.bz2"
  sha256 "5581ba65a85e9f89e929606d8c22d4d02650dc396ed884c95b70ab5d62bac7e1"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ff4fa37bdf0f3463b58ca1b21c9ccc727b2d6b802bfb563934460dfdca0087c4"
    sha256 cellar: :any, big_sur:       "31c81a055109276143fe71227f46e3fdeb6425e445008c61f800996b554de6d9"
    sha256 cellar: :any, catalina:      "acc33fee3b8541104707cc4897ff0f2b4c1a8702a7b0f6f53dc1e8421d671f22"
    sha256 cellar: :any, mojave:        "7f3c5881ea3843d3a7df49476119ac4f17d8d25a89b85516eae407d9413c14e3"
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
