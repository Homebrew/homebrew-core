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
    sha256 cellar: :any,                 arm64_sonoma:   "b6ea91414c2e5f797c41870b19985eb04668a0260629d90d64783387535b49be"
    sha256 cellar: :any,                 arm64_ventura:  "8b72f9b5707f68bd3007cc3e2eba399344f6b6969181ba2f23febcb6f025722a"
    sha256 cellar: :any,                 arm64_monterey: "092f12bebba91c2c3b207af7140d7812cbd179913f95c5c51bb4067a5758bfee"
    sha256 cellar: :any,                 sonoma:         "d543164d59d12848691cd72871736583a2899bc9651095f15d8b692daf142090"
    sha256 cellar: :any,                 ventura:        "32fb328cd86abe4d9007eaf21b10bda98b2cbfdfb5fb2251a82342a6bc80844e"
    sha256 cellar: :any,                 monterey:       "57307974bd131e709326062f8a0302ef17a3bb6a172f24df39a56b4ed933a071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bf97861be58932270466a1fc9afc27f91287eb22fb27ca94fdea2d5f2245f26"
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
