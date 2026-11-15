class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "ba9957aeeadb4151d4486f11c638ae118c00210fa4906daa7b30143aa341e690"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c73d14a608ec13d72650b3c30261826bd08c889776411000d93c82a4c5707aad"
    sha256 cellar: :any, arm64_tahoe:       "93142d78e65eac5121d6d4e4a9be9b38979714d767a69061abc88f7281de5182"
    sha256 cellar: :any, arm64_sequoia:     "f4eceaf597931a5aaaaad62238abe9e92aa3ed9bf0beadc569eb5dc14a928ebb"
    sha256 cellar: :any, arm64_linux:       "ba55c1a73481ae0bc3d7cedeae141a47f05893c7c4bbba172c9c123701eea440"
    sha256 cellar: :any, x86_64_linux:      "8c9e50969fbd456b6a8d2c53650f91d273668dddcdb6319521486fb8a15630a4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %w[
      -Dengines=cpu
      -Dloaders=all
      -Dsavers=all
      -Dbindings=capi
      -Dthreads=true
      -Dlog=false
      -Dtests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("pkgconf --modversion thorvg-1")

    (testpath/"test.cpp").write <<~CPP
      #include <thorvg.h>

      using namespace tvg;

      int main()
      {
          Initializer::init(1);
          Initializer::term();
          return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}/thorvg-1", "-L#{lib}", "-lthorvg-1"
    system "./test"
  end
end
