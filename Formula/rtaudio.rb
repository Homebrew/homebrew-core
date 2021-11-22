class Rtaudio < Formula
  desc "API for realtime audio input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtaudio/"
  url "https://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-5.2.0.tar.gz"
  sha256 "d6089c214e5dbff136ab21f3f5efc284e93475ebd198c54d4b9b6c44419ef4e6"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?rtaudio[._-]v?(\d+(?:\.\d+)+)\.t/i)
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
