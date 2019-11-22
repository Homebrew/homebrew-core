class RtAudio < Formula
  desc "API for realtime audio input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtaudio/"
  url "https://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-5.1.0.tar.gz"
  sha256 "ff138b2b6ed2b700b04b406be718df213052d4c952190280cf4e2fab4b61fe09"
  head "https://github.com/thestk/rtaudio.git"

  bottle do
    cellar :any
    sha256 "3bd5402da0ae1e25e31f77ca84c15ea33b5ef038d82831d25702b5a481c884d2" => :catalina
    sha256 "4db658b2cf66faf2c51ae7176ba7b755c6deb9b65c73051495e11ba0801ef1e8" => :mojave
    sha256 "d6e1587636446e2e54fb58faf871a71b82e62c8873ba15ec3edf3dc180483738" => :high_sierra
    sha256 "05b1394b494ab9b9bdf49add3935835503e9ac487993dd13d6c22a8ccb911133" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/*"]
    pkgshare.install "tests"
  end

  test do
    system ENV.cxx, "-I#{include}/rtaudio", "-L#{lib}", "-lrtaudio",
           pkgshare/"tests/testall.cpp", "-o", "test"
    system "./test"
  end
end
