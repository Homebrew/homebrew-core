class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230326.0.tar.gz"
  version "p6.0.20230326.0"
  sha256 "cf379bbc7a16d3b030d483edf7432505e15b998ff4473a41bff66bbc1aa0c7ef"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "857c4f83558be288eafe51302c2497b82ce56afe1a5026beb02802280d28aa41"
    sha256 cellar: :any,                 arm64_monterey: "2752d7fcc76e6017a59e474ec8cd9a01823daf944ea66703fba72d780b6b953d"
    sha256 cellar: :any,                 arm64_big_sur:  "69ed01efed97fd1ee704a4abdb7117399052d70a33239bf19c124bcd18f0f402"
    sha256 cellar: :any,                 ventura:        "7de7c08a92ffb3ce085f747df2557cff1e5d819b3c45583703984e1f5fafebaf"
    sha256 cellar: :any,                 monterey:       "75369ef274be640120525fab7c1f044b0832ad9bfdc941540cd4bceed89db37a"
    sha256 cellar: :any,                 big_sur:        "ca85b0100f7a4201787b06bae84e7e1be9a8b93a7780df2e6aa2f54f6b0bb991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2506d514e387ad0dabffbb8d211b523270faad54ed25ea5a775e97db999a0cb3"
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
