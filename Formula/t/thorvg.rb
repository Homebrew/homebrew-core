class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "cd466f4abf2522a6dcdc1a69a75d04a214b7163c89731fb8481eceaa6cb73842"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dca437b145825b7449c2250e397d9a9353db88a0fdcb8a6bfcd59c0294a4471f"
    sha256 cellar: :any, arm64_tahoe:       "3eefa766d175587d83110d5106deacc144a890aa4975331cd8ba03b6c6c82038"
    sha256 cellar: :any, arm64_sequoia:     "3adbacc1c1830423bb887ffcb43d89dd852dfb3bacc2e1cf962fe90c01e45c70"
    sha256 cellar: :any, arm64_linux:       "106a6d5774c081e03dafd73e6a0a402f1ccb54c2ec86c16ee84724967eea8da7"
    sha256 cellar: :any, x86_64_linux:      "91ffe0f218f676ca93eb04f3a298b3fb7c7f3aa31f4037f9f2712f4022c0a745"
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
