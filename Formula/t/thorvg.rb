class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "efd8162187992d2ab33851a6da1668f05e2b5e725b307b344d2c1bdff44d7b0d"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    manifest_sha256 "91b1f09e25b299b8df58c93f6e1474d28b9f29e4b221897eddcc74de5f21db8a"
    sha256 cellar: :any, arm64_golden_gate: "0d8799fed957880c650e10837b47afc2687974f9c90d7a45aa1ef81210cbd36b"
    sha256 cellar: :any, arm64_tahoe:       "78f29ade5ee049a38ca9a6e5a2c425734075c183abeb2368d953297f5d2227a5"
    sha256 cellar: :any, arm64_sequoia:     "fafd4c44bdbddbc15725290560bc609927dbaa5b6a74fee20b271b2af7d9865e"
    sha256 cellar: :any, arm64_linux:       "0b70bed6853bc1225fcedd4f078c46fcfed6192b7400225074c8aa6833a782d7"
    sha256 cellar: :any, x86_64_linux:      "291698169504b231d92df0ce822d54ce69313993bbb8f3345698c4453ec232a6"
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
