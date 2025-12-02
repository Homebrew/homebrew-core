class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20251130.0.tar.gz"
  version "p6.2.20251130.0"
  sha256 "b13de8f85bebc2e6421fec4030893635b7730d33cbe469df04de091f7f5ad385"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa3313e095bf1c72a464e72bfb444ee9ecfb59cb3d528951eada3ffcba25238f"
    sha256 cellar: :any,                 arm64_sequoia: "2c733f80db53d7c7cebc518ae646aae81cb4989eb7f25428fd5e5aa64aead2bf"
    sha256 cellar: :any,                 arm64_sonoma:  "85c520639964198818372b8db5f8198f1c1b112096bf1a45b01b72807369f5df"
    sha256 cellar: :any,                 sonoma:        "fb904ebfb8a766f3a3b0d236d2a656b7745da05d9e61be3e2e4dd5047a53d6fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d35f17175ddf0d095b125d51214f3de1398723f465be7d5cdbb24a13e095a6b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be31d65d0618b8c416465eb186749fefdde1aec34625870553814e47baeb3cf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "both install `ctags` binaries"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end
