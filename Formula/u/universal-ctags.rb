class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20240421.0.tar.gz"
  version "p6.1.20240421.0"
  sha256 "6ffe18629301dfbcef34e60a861ef583bc29c41b69de87b19849ed6f3598533a"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2fb14aec1771ec95f332a0f6bd9d26ca87e42aea91fc5b69e0d2c175501ded92"
    sha256 cellar: :any,                 arm64_ventura:  "930e0e5356632c08d1be00a0626e2de75e322ee2413d9be0c2b10c7c71554952"
    sha256 cellar: :any,                 arm64_monterey: "1bf16329c587d7a4633ee259c4c8125737aa72982d016dcc36a651e7bcc58ce9"
    sha256 cellar: :any,                 sonoma:         "99aaa1eda36b4ea721d8b87d65138faa28f1aa1c729cb06c784b7fa8d48ee0db"
    sha256 cellar: :any,                 ventura:        "e79938f117e3aa50ec389795a8b2e881a90bdc5487948a63e345f0fbcfec3637"
    sha256 cellar: :any,                 monterey:       "34604c3c2bdf9b21a007d79d09d027a174ebe6bb44ea61093840707b455cb54f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c8c9a387da9f11d263decf4320f68267921c28e87aa802ef0e0be4e08fa6f7d"
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
