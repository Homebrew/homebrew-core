class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220109.0.tar.gz"
  version "p5.9.20220109.0"
  sha256 "74d19d6201ce57744f3e72a4613f78253990ec5d35536181ababef8a3d256575"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ae7a514e355c86a395883613dcc2e717b897c6a12e9e24a8a3ec3857989c6f07"
    sha256 cellar: :any,                 arm64_big_sur:  "a0e2afdb943e46b7ba4af0bdd5ba679be41cd6a7e4ffc66c3f538e2fc5afa271"
    sha256 cellar: :any,                 monterey:       "b0abfa984bd41854fa5f2edcdeee77cbe24c916c684947ea118763509d0ac8c5"
    sha256 cellar: :any,                 big_sur:        "0d1d99f6ff1285c290e83b57e06fb62522513f093951b39f035b37718dfd358e"
    sha256 cellar: :any,                 catalina:       "1ac646e8fc1e5e2d63a0091d6d9e8c8ad93f21997c1d3ffb2701205f38951277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bd1501c2919de4a8caf7c01baf7ca8a71e8106f4fce260cec5d2b3567169bf3"
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
