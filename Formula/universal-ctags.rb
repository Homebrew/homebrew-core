class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230312.0.tar.gz"
  version "p6.0.20230312.0"
  sha256 "5535c8a423753fbeebe64222eb1301eeec2d0bfdced8e2e881ccde4937724b8f"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c87df5ece1a2ae6ac02e32dfa1c9c58b0533185668515b0ae5462188194bfa5c"
    sha256 cellar: :any,                 arm64_monterey: "20a7a5e4f8f03b0e850ab97e28d7a240d35eab024e695f0f0876bbf73d1a0603"
    sha256 cellar: :any,                 arm64_big_sur:  "1ef60a1b791d57e6251ffcd651a3ea0732330371aac5ce0c75b1eb11f744195f"
    sha256 cellar: :any,                 ventura:        "e16f61e02e621637ffc491660fc5d64c4dd38003cd65a9e6314812e267a34151"
    sha256 cellar: :any,                 monterey:       "597907dedc5c32e49a65564364488fbf64998cce73c131ab32e1abe7021ee0c1"
    sha256 cellar: :any,                 big_sur:        "5979150c2f5b7bc5cbe5d266be8849603361a4e9f4e7fa7b9daf65a90c864cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37379e55b523ccee5626546b18dd606c01dad68dba374a821f98ed1f2b97dfcf"
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
