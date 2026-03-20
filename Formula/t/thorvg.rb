class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "0805e248778ec23f5a02f371aa92675151a2c9d652c1dfaacad2192ff7f7c873"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4fcbdfedc8c0d7939e3f034357bb38e8483537ecbf003dd3dbe2c5cd01530716"
    sha256 cellar: :any,                 arm64_sequoia: "5d3f97665d925f19a7151f16d65f40b8b694f03088a90bdefd7fcd0e7dece434"
    sha256 cellar: :any,                 arm64_sonoma:  "24a2eb082e2ac0ad4313184fe24eb02068e6a10dedf6494325ff3dd8fdd19a8d"
    sha256 cellar: :any,                 sonoma:        "f363f18633cae5ac6e6510bd7f710c9c64572c0e0a2bc95106ee17f688141bc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "897c8de135748a7d95d2a6c6be49301cbd860ac38a368f89744fc10ec5635b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3245e2f248595d4a0650581c64990374ab5fd5e0b1c83d1a401ae2990231f528"
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
