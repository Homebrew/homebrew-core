class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20251123.0.tar.gz"
  version "p6.2.20251123.0"
  sha256 "85806a486a3b24fc58dc64eb3a183b3cc88951c2c5e12aa59c01cdd076b97308"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "77b7f805634976a9397f0cb75cbab12e8c9293c8f884cbaae06637fb3cd68727"
    sha256 cellar: :any,                 arm64_sequoia: "a87574ef5a2ac5399854920abc71517f270267e67dc7a64732dec65142d283ac"
    sha256 cellar: :any,                 arm64_sonoma:  "7e5df048bcb5ae5b044ea5127c10a3ffdd294d40d0627971d6c11adb12416f1f"
    sha256 cellar: :any,                 sonoma:        "7867bc8de48bb65c7ca0b385c3d77ddd6e7c8b44dd1070b968937b52b7a3ad8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "250250a4b4a40425a5851bfdb9cf06d6d68631a6f024e3ffdcc9f14a5605e42a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b87ca1eb60853ae4e972636aac8efe0033b8ab487740bf8527f420e850b8da87"
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
