class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20240818.0.tar.gz"
  version "p6.1.20240818.0"
  sha256 "597ef176c5690985579476ffedf81896bb72605e3f84c43992d92274f362a0c7"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ff702991cb422a5516006f897876f512b6bb141cf13fae4044317a31a8fc9a56"
    sha256 cellar: :any,                 arm64_ventura:  "b624fee915944d8b2901eb8d3304bb39e7b401141275260ab57c6e2f884cd42a"
    sha256 cellar: :any,                 arm64_monterey: "612b85756c931fd26a43d2cf4231ef2e35839a0538505defe39660bed565df99"
    sha256 cellar: :any,                 sonoma:         "a6dcc6a8ace513fd6459c34d27f55bb1f69348c662cadfcbea47fd5a6cb80170"
    sha256 cellar: :any,                 ventura:        "49f6b272542dad5afa36127423cf64f2a56cc328f11529072205f674a56ee8e1"
    sha256 cellar: :any,                 monterey:       "3f360c62eab992bcdc77b9c74a6d13391f9a249800b29201909be25d5933441d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d59a4de98d795dff30a4bca58c40d896f34f8db1e00e3a24d41a4574280ebb16"
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
