class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220911.0.tar.gz"
  version "p5.9.20220911.0"
  sha256 "850b0e2f3d72cef5d962d90328e7463ee8fc49c19a7816fe26b1328f9334b27f"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fd0091d92bc23a95b0d477224df0c4a177bc0f6ae26eada5e3967936d1601e88"
    sha256 cellar: :any,                 arm64_big_sur:  "568d3c9dc00e1e6d0e988ba2e69125f679bbab1de6c971c712ea9e3179dc0383"
    sha256 cellar: :any,                 monterey:       "f0fcd5a4860ebd38c3d757cae686cc6a081ba25fb961e2fd0835abed65fcecdd"
    sha256 cellar: :any,                 big_sur:        "d48982ab9293c187de96c887a02a025399446fe5658dbd30b5a107edff5235d4"
    sha256 cellar: :any,                 catalina:       "247508d9df343dde5545030b92c11a8831739b8b91eb3bb7abc8d1ac8c3f07cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e2f71fdd773582752ccb8942cf3b8981bae71e98e29283725fbe1a02fadf107"
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
