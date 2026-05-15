class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "e25f23c0698c739affd1a092f77d0e56d4888deafa05da37ba1eb0f3031fa5cc"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a8e3f24a8d9f951a6cb6d2427919cb0af4bdbb30722e6389d3620c5a5cad772"
    sha256 cellar: :any,                 arm64_sequoia: "33d04b9b52fbd73afbd63e3cb71129db2ad9b6225b25a129c75840578f168dcc"
    sha256 cellar: :any,                 arm64_sonoma:  "a2f990b9f004bbc284c61658e1d0b21c48c9798dede4e10e7048d40a2b4a06b5"
    sha256 cellar: :any,                 sonoma:        "51ee0ae71e9e8b1814f80efa9d7a4b10db5958a02b984ab43649c347b5eab9b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb1aa2ac2f32ab691d38f04535e95d43fd66952e9bf35494c7d2e030d4e91efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9607cd92bba86c1da23c0ae565c8c227e147f2ba67abdc7a14e1d4a08024cf45"
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
