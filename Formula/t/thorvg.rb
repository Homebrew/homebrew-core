class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "1a60b794eaac5717ad79d0c7e3d189f46e21d469b3a0013d7804f348fbacdf17"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f21cebc813cc64e43a1aad142679fdda03cd3511430fef91fa9472ddff0aa9ba"
    sha256 cellar: :any,                 arm64_sequoia: "5809dfa078528bcfa1da7fc2c11d89d78693efe6368ceb6086987d88986c09e1"
    sha256 cellar: :any,                 arm64_sonoma:  "46a2c1efff5c80880cfa2815649ed1412a4ce8dd7c90934c135f5f8cc9ca4775"
    sha256 cellar: :any,                 sonoma:        "e27e2645dcf4ba225ae952943da69129b51c6e07082e11c5ee2d700f52895900"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60d9651d173e2a53afcb6b32ab1571cd9aea141edc37b3ae918ddbd2f2d6b97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4279446c80d0bd447f2640a0dedd517b80db923d15dd4cc030a0f3368474fb6c"
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
