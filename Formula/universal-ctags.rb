class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220220.0.tar.gz"
  version "p5.9.20220220.0"
  sha256 "699d3c08181e2da539e7dbbc6210f9322900d6ba74c28e3f85f5768c01269c8d"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3819c5fb5ca7b53e094a27691df7237238451d37a410a499972cfa3f0b946ae3"
    sha256 cellar: :any,                 arm64_big_sur:  "0db126a1fb3fb67a5f45f0f4940d717359cd9468b4266c897ceebdfa599e5615"
    sha256 cellar: :any,                 monterey:       "837482377c3b65cf1315e3bc9c1a99d9c1ec66128802f69c2e018fbd9ea9071b"
    sha256 cellar: :any,                 big_sur:        "f1868f7e09a2994d1dd6f9c4011fd43182bf3dd8c556290d0fc29c781b91f32c"
    sha256 cellar: :any,                 catalina:       "8008e82948d99cc5978ad97b1c08e6124e4d5830658fa8e239e847c6dcfb418f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ebb090bfddadc60e5ad7b62f79c4360fe99f2e78b4bafddcfd75331161b9bff"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libyaml"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "this formula installs the same executable as the ctags formula"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    EOS
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end
