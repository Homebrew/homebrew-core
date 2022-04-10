class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220410.0.tar.gz"
  version "p5.9.20220410.0"
  sha256 "b98d21891bedcd94165586a226151ca0d6bf694d7e3617428109b32d2901d267"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c31c257342cb978917d4ad35908cb3b93ee609c37d5c3346ea53f23c2098489c"
    sha256 cellar: :any,                 arm64_big_sur:  "999058f7f0199a88f6b6c3fec299ca0967da6982aa062838bc362a0ddf905eed"
    sha256 cellar: :any,                 monterey:       "da6f4f1fe85699c3ffe821629be65c4647d59f09289fb5421749493cf0b6af33"
    sha256 cellar: :any,                 big_sur:        "696e59ac7a273ffd2b8d93ac65e5739dbfc25e00acc16e9da03ae60fae917211"
    sha256 cellar: :any,                 catalina:       "2d96dbea561f28b3ccd51f6247b8dce81cbf1fa902ecb18755af9c10c744a05a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "829a96b9ab5d62b89e5d653a265e7cd3241553d266e265013127d8b2f01b684f"
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
