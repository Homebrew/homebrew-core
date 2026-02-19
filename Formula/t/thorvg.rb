class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "061343ed560f08ef2f7b48a7f6b684ae6bfd50b7904599d8581e466b2531844f"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2d6bbaef2d44857ee10e04b8cdef4181378f16495bf934431017fe33616caf7"
    sha256 cellar: :any,                 arm64_sequoia: "bf507d64b82cce95df0890fd89fe8e9c8ef60317cb5c0ea73f9e2c7e85abf4a0"
    sha256 cellar: :any,                 arm64_sonoma:  "29a288e9a939e872d978d5c794097ef1035be761b5360e56805c0b7c27f54030"
    sha256 cellar: :any,                 sonoma:        "f3120164f30377e309a1649e623091393eddea76a05f8078b13f44280ff63a14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7da32b612dba76ae26837527dc1ef78552a61b713a4e8314970ca62d34b5a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9034ea438c681c3317640249c36bb9bb37e8cf7841f337771f638550fa32baa4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %w[
      -Dengines=sw
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
