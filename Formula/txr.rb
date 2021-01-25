class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-249.tar.bz2"
  sha256 "b3f13bdacec70b24bbfae3d731b9986410901c1425f7024a2d8696827e76ae3e"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "8f85096c67e6121717cd4613fed3c1eaf46270fca03ef176434a845c72676461" => :big_sur
    sha256 "65be4809baf6a905d4293d5b322695e65ef73b6159991c8b9e6ebfc4223e8cac" => :catalina
    sha256 "26340b55c6290b4bc1b4b258711ce51174e38cd8efcf83364e43bf18957a64b3" => :mojave
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
