class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "59c12500b7c2fc426e89667b3e4f3fdc2ff05a75cc12001a22c5f58fb1cdf592"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a6b99e05374ae594d991ff58ac0fece37071ca94d2a7fc27669bd17166e45ebe"
    sha256 cellar: :any, arm64_sequoia: "959ea744652c8b1d669335571c44d8044a762bf2043328ccf79b3a8f9a256fae"
    sha256 cellar: :any, arm64_sonoma:  "d41abf1592bf80c5bacd79e33a58807b5d8d6d8fd4ff64b89d3a496c74a31c8c"
    sha256 cellar: :any, sonoma:        "b0b42ce8626676f93c9e0d34e4011aa1c56d7a0f2b082278f465b3c0e980de28"
    sha256 cellar: :any, arm64_linux:   "a7033878752aad30ed72728772f77817d2e6cee09f8ed999b2cde72161a1118a"
    sha256 cellar: :any, x86_64_linux:  "0a990b6f7349af6bdf4b0acb423fcdbcb80afe9d80cc4835f79ad615e3188575"
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
