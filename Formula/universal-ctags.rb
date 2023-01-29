class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230129.0.tar.gz"
  version "p6.0.20230129.0"
  sha256 "fc551175174d3cca0089d411ddc8fea916550dbb8a4c0fe49487e8b36b3cba54"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f6bb946de76599632564494f4a1aa7589bb29ce57635d229b6f40c6e28e7fc4a"
    sha256 cellar: :any,                 arm64_monterey: "4812a7102abebc7ce12ec9eba5efa55cdc80aa741d2ca7d22e27696b273e690f"
    sha256 cellar: :any,                 arm64_big_sur:  "db977c0385c4e72a87ef238dc9f6c47e699e598a56a2eb7df69853476fafe387"
    sha256 cellar: :any,                 ventura:        "1fb5bf6e9b95ba2bb2e9f6c8fa04e3de09ef0ef239bf7fc5016550867361c366"
    sha256 cellar: :any,                 monterey:       "3e60df4b9b21d38620fc285f7100f961036bb724e7e02a3cbeed397f00327996"
    sha256 cellar: :any,                 big_sur:        "2e6a0876d436f1f622e2d92a8d6d780e0899e9226b7a948283870b8b7548dcc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a8376e8c6071c53f5765f5a4687fedbdff6a799eaa144ef7b3236fab7638146"
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
