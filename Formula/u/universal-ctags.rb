class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20250928.0.tar.gz"
  version "p6.2.20250928.0"
  sha256 "67d3dba8d93fed706a7b20590b29c3b7b3bf693f11f1d52e24a6e737a069f25f"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3fef6072ad62f206469b0f387118043e4f398106088eb856d0cd31c39f6cd3ed"
    sha256 cellar: :any,                 arm64_sequoia: "783f4bb438ccfbb586504700475f8dd035b81d94bad8f269d2b10f308a53a440"
    sha256 cellar: :any,                 arm64_sonoma:  "3892dc613b82953517ca66a7785d1b4877953ca20fd9494922352c61c5dda27f"
    sha256 cellar: :any,                 sonoma:        "44ca7c1a036dd8cbc405616c25c03ebd8e7428ca9947a19c200576a399bd6977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "743f64807188a85cf7351ec718eed1a860414c9ff0860a0fe9895a251cb8c88b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba39a512cc943e2110e116a84863ef52cd7669f8a5e5eb1d791c334946f51dc4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
