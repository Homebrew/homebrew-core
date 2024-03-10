class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20240310.0.tar.gz"
  version "p6.1.20240310.0"
  sha256 "915d8ec99a927df1e750d0ff17a6dbf012234646799a7f8bb19f69cbc28fb00d"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ca571c73290b539111c387af93ab9308313133789e825064abcf98c6ac854d9e"
    sha256 cellar: :any,                 arm64_ventura:  "259c75d3619192394b20efd0c006e91603553326b5be59454378ca4c111afc4c"
    sha256 cellar: :any,                 arm64_monterey: "43f97b39e534c9dea9f6c5f6d58f413a6aad04c483ad5389a0c57fc73c432be2"
    sha256 cellar: :any,                 sonoma:         "b74787d7bf33ffed000668faa8a8e28ec1e420d7811b732a15512efe47889967"
    sha256 cellar: :any,                 ventura:        "6d17e73cfb345e4c8fa8b3de58b6b1c02b600c09f107feebdf86b9db7532b255"
    sha256 cellar: :any,                 monterey:       "a718a89ff23ff0425e749ff9001928474d5790fbeb36a2b0b7fc9b7b8cab9fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c18d5e1c5e86b60a546af09113cca3fd81227cf40958672b0d312f9db3c3a9b"
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
