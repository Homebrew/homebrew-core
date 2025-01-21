class Rtaudio < Formula
  desc "API for realtime audio input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtaudio/"
  url "https://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-6.0.1.tar.gz"
  sha256 "42d29cc2b5fa378ba3a978faeb1885a0075acf0fecb5ee50f0d76f6c7d8ab28c"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?rtaudio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "91a97a9e4ed02b0fef4016d7ee2916edce3c41251bf9942f4aef4a9148c382f3"
    sha256 cellar: :any,                 arm64_sonoma:   "1d56ffbaacd143c4ce5215d42f5424d42dfd947bc26eaf57830eb51e7546068b"
    sha256 cellar: :any,                 arm64_ventura:  "483296d1cc1b969448614c1a22d004a1222270832842dce62be151465fd21753"
    sha256 cellar: :any,                 arm64_monterey: "87c6a5b3c3eeb5b176786c650f5606de4cf7936ddf152fb669456eca491512cb"
    sha256 cellar: :any,                 sonoma:         "0a25a53c7f0cf7dc23dc4e4e9ecaa7df13051b16b3c8513ece3609064a74bab1"
    sha256 cellar: :any,                 ventura:        "a3feed53dc08f1210bd32431b16fc0bf0264dc66144ea64716b95b9a34e80902"
    sha256 cellar: :any,                 monterey:       "fb3184319287e1a9d056b35033806116fd44390f406cc3a19f2d9fc107148318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5115ee3bbfff48c47089c8051a0826ce35277e2d75397cb8e1b0fe39e8933588"
  end

  head do
    url "https://github.com/thestk/rtaudio.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ENV.cxx11
    system "./autogen.sh", "--no-configure" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
    doc.install %w[doc/release.txt doc/html doc/images] if build.stable?
    (pkgshare/"tests").install "tests/testall.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"tests/testall.cpp", "-o", "test", "-std=c++11",
           "-I#{include}/rtaudio", "-L#{lib}", "-lrtaudio"
    system "./test"
  end
end
