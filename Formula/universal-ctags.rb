class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230507.0.tar.gz"
  version "p6.0.20230507.0"
  sha256 "5545f0efd452095da8172daaf7b59d748928155ba7a612e26177bb700b631720"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7b921fa205ad5e3fac5dc9d0837194ffc4ed39120314b47cbf3711f12e59162d"
    sha256 cellar: :any,                 arm64_monterey: "202cee3a02ad47906f8faadddaa2e9b24216e6114b51e3c788ef14e91d862d63"
    sha256 cellar: :any,                 arm64_big_sur:  "a978d591656b6904e287948f1bd2d578cbe67008a6ae35755fae0abec31ff421"
    sha256 cellar: :any,                 ventura:        "3823a64815cf1608bd3611b15a62f6183decc90403593c03ca3cf54b8c9d23a9"
    sha256 cellar: :any,                 monterey:       "40b4732efb0038915f61dba871aee50f42340fe914d0a992067ff0e214390db2"
    sha256 cellar: :any,                 big_sur:        "d548fb970c77343c3c5bd98c3c7ce9d02811db33889c476a793f0d9108311c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d6442ae5819c775d48d3b26deeb9a009a3b6f233abf8ec9c27b372068e4c916"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
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
