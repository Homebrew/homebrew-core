class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220612.0.tar.gz"
  version "p5.9.20220612.0"
  sha256 "a925564b843ea656aecca8db4f538a3e8d69b2544543c4ee190904b8d9e0e99c"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "70e4ddb9009c14cc44993b5166f17b4ba5ed94280f7fb8becb2a0acf594487c4"
    sha256 cellar: :any,                 arm64_big_sur:  "6952a9680eca846b53530638b434fda449f6d63fa78e585013cffc695e7d35c4"
    sha256 cellar: :any,                 monterey:       "950abe6849583c2efd99fb919e7b5667da3319e82bc85ca8baa03df635f9147d"
    sha256 cellar: :any,                 big_sur:        "84b98a0eceb7db85146dc1824aee5d07301870db304452bd1d7ab16c10dc6e9b"
    sha256 cellar: :any,                 catalina:       "afedf55e62f23bfba9b86756df74d1140d3fd51f03213c7e426819b956580d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c67abcc2d77bf8ea0d1e71c80decf8784e6fad5f2988a5f938767f719e07433"
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
