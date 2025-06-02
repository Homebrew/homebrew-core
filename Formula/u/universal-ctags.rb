class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20250601.0.tar.gz"
  version "p6.1.20250601.0"
  sha256 "52f1c169f976d8a3e66b85f1cc14de5e951c1acbbc227b924014746d8090ac34"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c10ac7ce7ccc02130c039cdb0ae97ee35d45083fd2529d703d43377f501bdb89"
    sha256 cellar: :any,                 arm64_sonoma:  "173cc0be83207b80b80e28114618253a7ab1503870cb195523b83c7ab8d40909"
    sha256 cellar: :any,                 arm64_ventura: "f5dc161b3c2e363f1656d547ac89a124d98336d867afcd91c4bbaaf2ff610ed8"
    sha256 cellar: :any,                 sonoma:        "cfcb78753fe98826a9e22cd67e0952a189f775677c5cfc07076665d60cc022dd"
    sha256 cellar: :any,                 ventura:       "3c839c7bcda55226fbefb3b87b28a68043cae67467e1f3ec563f2d8c2de5c249"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2a8d754503138bf06d0e4317bd5459d025bb258e6c8a5486b3a90ef02621944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cf0355ca275844fad3f9605204fd0137c1dc587ece49a4e3d79c81dfd1157ed"
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

  conflicts_with "ctags", because: "this formula installs the same executable as the ctags formula"

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
