class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "f9321bd87c3f709c1591424a491cb492be9ef81436427acdc16ff57be7d1bc38"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eb27052a5bec4c45c2fdcb6859ddd2256f94cddadda7630bda1c5a42975e7359"
    sha256 cellar: :any, arm64_sequoia: "aabcda85b2834e1a562941373d749b4c4212be41628bada01554d42876b7866a"
    sha256 cellar: :any, arm64_sonoma:  "85ff29bb8f42152596858c673765b9c612f0785ba90bb771db2cb9743d5f361e"
    sha256 cellar: :any, sonoma:        "9d922286cdb51204f14535fff90f16bd7c901f20014f0085e968e215f21b7527"
    sha256 cellar: :any, arm64_linux:   "2291083e9d89e32571f36bcad6835ccd0c3885c96de97ef55d0bfbdf94ae8070"
    sha256 cellar: :any, x86_64_linux:  "20da883f33b5d804df96f083909e6797cf541207e85295c4f99c082950b16931"
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
