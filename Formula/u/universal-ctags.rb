class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20240414.0.tar.gz"
  version "p6.1.20240414.0"
  sha256 "3b65705d58678c44ba499a38b9d5e778d7f9e89cbbf6398fbc7b51bb75f0459a"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5bc6205f6aebbbf7f4a9a82be7b6235497bdb0d136a3ba36cc91f84a1fc2fddd"
    sha256 cellar: :any,                 arm64_ventura:  "2c9c1e5351b619bb8daf86a3fd508753b96f1d23d11a1b11136fec9475b14536"
    sha256 cellar: :any,                 arm64_monterey: "3959b7d039bad1d31b3055a8f20815cd2330d86f67a7ca9612f4fafa5d5f0d12"
    sha256 cellar: :any,                 sonoma:         "a9a4b8096741472fe2a7bbe4e4c0a745d93f9ae6ad46aa114f0d3e43d4e312ea"
    sha256 cellar: :any,                 ventura:        "ddef6f7ade15a82ffe19034342922f4081bb7588bac92922971bc1709678fd97"
    sha256 cellar: :any,                 monterey:       "900f2f18b2c8430b47fec9e2716df3325cd8818b7d863282e5592a078c07bec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e72046c600b0d12c8e3a93a76b582d9bd867497dc906728406b5be2cf8708b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

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
