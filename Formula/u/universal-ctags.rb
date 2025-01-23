class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20250119.0.tar.gz"
  version "p6.1.20250119.0"
  sha256 "6bd076dd9bd559d714923bd94b21c1870d5d284986cb5e70c1bf9a38e0874bff"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32830f581b83643b25c20c8a8121c792e3cb034f4245646dfa717056aeeae5e2"
    sha256 cellar: :any,                 arm64_sonoma:  "f7e5f56022f2379c07f4b90004435673d8ca1acb52ab02818280ad2dc2e99025"
    sha256 cellar: :any,                 arm64_ventura: "e01fc26e3143f0f7d87f6b96d126ba0b889c26648b6859423bf549f214290a15"
    sha256 cellar: :any,                 sonoma:        "348772ca8550f499a2a095e66d47c646e8860afa4b0c12f7a584a177663beb9e"
    sha256 cellar: :any,                 ventura:       "a270e5532ff4c50979c91cb26efae1fe16644b2a90b2977268da14e6082a62ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e93ff5eaf8feb01b95355424270a101a483cb9a3ab32fe0eb13c67aa0f2dc0b"
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
