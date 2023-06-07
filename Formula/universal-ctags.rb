class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230604.0.tar.gz"
  version "p6.0.20230604.0"
  sha256 "f02420f32f28a59454d096745a27d631c126f9aff406e8173fc5a36bb54ea0fd"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7dab78747d53da6f52c64fbf570087952b435e4bcbde905603b2a16464e3b217"
    sha256 cellar: :any,                 arm64_monterey: "80c51360a158af2f14a3333e1900fbaac0c5591f6dd7cab84f25a2285ea3c4ad"
    sha256 cellar: :any,                 arm64_big_sur:  "a196db464f6daedcfa7c2324b770e4dc66e566d4c57a920bd64f9d77ceabd5b1"
    sha256 cellar: :any,                 ventura:        "d45c5769afaa6ba0b0664a3ae608dda79e3397bb40c29527d34d2d17a732133f"
    sha256 cellar: :any,                 monterey:       "9a2fed219676ee1f3e8bdb49d60e6d8cfe148b9adcb591076badf867db0c9c3e"
    sha256 cellar: :any,                 big_sur:        "dbec648f5a2ea7fb0a0d6483cea70872e35cab10fa4b786a55f4b6443492d101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a93444e724a0a01a3e9d1f54d0f001c80b2bfa1c23ea67c61971c784772a0335"
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
