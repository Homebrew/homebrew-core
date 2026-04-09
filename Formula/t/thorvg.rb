class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "96bd73c9b3f063251404609757301197d63b6a75e22c1527889dcaab3d5827a0"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "583bb154cb978b9edd2613e87f64f58ea4973b6e0f0d45cc4f1646b01284f116"
    sha256 cellar: :any,                 arm64_sequoia: "72f961c070fc684a9fa5976546a9ae1b7ef841b8b2f1834514672204710f1228"
    sha256 cellar: :any,                 arm64_sonoma:  "8f2c259325553de0ffd82322a7058fbd6481dc0fcf9de4b63ceceea7d60a2d11"
    sha256 cellar: :any,                 sonoma:        "5cf3161e437f92d33f25f85985ca1507d2ce6b75fdaf25bb18199403f1f9b0a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23ac4c4a42374bd90f47138bc6f23bf479205a8c5696c331f54fc9e65808c06c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d843c600d7c3a4fd2db35cc50e85ec4f3caa0779485d15ab3270421f4fbfa332"
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
