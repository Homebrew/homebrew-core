class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230319.0.tar.gz"
  version "p6.0.20230319.0"
  sha256 "02f76b2c70e97ca540a4e775005c387cc308133d576c705aa276da6f76554698"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b9162d3c98774aa570b7c6ab5dd6c95076a3513bb85b04d81062769dcc9d8ab4"
    sha256 cellar: :any,                 arm64_monterey: "3b60a043b0040a71e4a1957d16ec6e3414da631bf6db3b199e546cf42c0330f2"
    sha256 cellar: :any,                 arm64_big_sur:  "1325132db9f858b72a658b63dcbbcd85b1c1078d69abab940709b287553e7b6f"
    sha256 cellar: :any,                 ventura:        "f78590a60340532d47fab291a58dabb72af6c005ef605574358fbaf14cc61619"
    sha256 cellar: :any,                 monterey:       "f37363073076f54f10cbe16f2057e8b55b4fa771857300863bb39c5cdce15cc6"
    sha256 cellar: :any,                 big_sur:        "82c6fb77b9f4ef754dbfd73344751cc4bffb9329c414054f25c9c8905025101a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0656a716a10bcc03569277186259213ec31c2fc5ac104578acdaf71d08f52338"
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
