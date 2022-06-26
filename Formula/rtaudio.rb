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

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ecedd19fd1867f51b7c8bfd6f408d6b33619f544a536d8145bee666c1940e75d"
    sha256 cellar: :any,                 arm64_big_sur:  "820e94dc0c131b738c77bd0f06658ccecfd284197fbb9051859751cfee6d7090"
    sha256 cellar: :any,                 monterey:       "f52d926c30030e41676af3009afd40bbac63810cc0ae741e0adfc47df750e8fe"
    sha256 cellar: :any,                 big_sur:        "6451351bb885f61f5e6b9cc46da7fd4a64a59d67177d6dd033c93279c53726e9"
    sha256 cellar: :any,                 catalina:       "16a170ac4384a2b83dd5dda834a8bfe0edb7f6d81d123150b287a11bf3b915e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3452c83b3b53442744ba984f908c42e9d0b4e7b17f10167a1e6b55589890cdd6"
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
