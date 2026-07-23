class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "73943bcf918c9ffdf11acc53052ba5cb60a7047b1cfb2067afeb62e0c4d9417d"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ca27746d0b2c439b916ac151d7eebc695de9ab8a90b0d7469cab59d0c02aecec"
    sha256 cellar: :any, arm64_sequoia: "b30155b33377fbe96f458351233614cf2ea9df13cb519c99604936d2321de772"
    sha256 cellar: :any, arm64_sonoma:  "8fa5d7cf9b21507dadb76e3cc5af2e8c67deb87d8f6a0711a332a1e9701ebd6c"
    sha256 cellar: :any, sonoma:        "34d6c19fc04353181feb914c63b29f27457b100ca3cf87618baea4a0ef9ac9b6"
    sha256 cellar: :any, arm64_linux:   "fa0e7900aab9f7fd4798e03953404a997e821f6b7d22a45e9cbe9b101f7bd55a"
    sha256 cellar: :any, x86_64_linux:  "3d8b714be48dfad606cb838590c027b3e632cad51b06bf02e2addbaf0f9e0afd"
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
