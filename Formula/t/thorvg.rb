class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "e541af1fc7e18e4fbf5eba098c638d28eb3562c2285b33985606ca2c7005ee4e"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "310501198361c253248571f3e4cfae19bb81c9de1c2d3399170e5871a3ea2c87"
    sha256 cellar: :any, arm64_sequoia: "86f1e9ca0852c0149986bf2c7e9363466c0601bca3915eb891e41e62f5f756cb"
    sha256 cellar: :any, arm64_sonoma:  "06330df37aeadea625cae75c38642365990f3bfae6a595dada48336fcf76c325"
    sha256 cellar: :any, sonoma:        "89cffaccd9b5844c04c02b056c25e126620edf49b7a555b320700639155f96d6"
    sha256 cellar: :any, arm64_linux:   "4dbfc9c924e8be5fa28dabcf08adbb2c92ed39573c5827a9d297751da3fb1a31"
    sha256 cellar: :any, x86_64_linux:  "81ed8d07dc3889eaec4e793fb64bde453fb7552e98837ab9aa51b059b5263a39"
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
