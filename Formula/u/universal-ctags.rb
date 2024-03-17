class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20240317.0.tar.gz"
  version "p6.1.20240317.0"
  sha256 "363a2e68267c54982bbb2f888facab28a13c39aad12f91639c3290a1ecc059ea"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "32dc55ec12a40ee260f8cc44bd1cb66b75e79fdaecffc8e16a0b29694239380a"
    sha256 cellar: :any,                 arm64_ventura:  "816a274c5f3621383929b0d5b62ded1d271d40374767fc24ef69c9181b8bddf7"
    sha256 cellar: :any,                 arm64_monterey: "d6f0e4b81b1f02f1a23814ff8297d9a2523802624c5f2145ab895bf28dc5e8f4"
    sha256 cellar: :any,                 sonoma:         "73e616588d3a200042b1fd10b36d5e374b2e67569f62a6f2e5c72ebb6d549c93"
    sha256 cellar: :any,                 ventura:        "a92bdbb86d18ec2c8da6ff735dc8c87456c65ea28f0702b275bc7b7de045144a"
    sha256 cellar: :any,                 monterey:       "938a98b873f9c5995d5c2f472688a5c831cb86d5a88a0f462d4b476142fd12ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6309699c21035806c21735ce437d01a5357f2edf0ae8b548e4cd68d9265059fe"
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
