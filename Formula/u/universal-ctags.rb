class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20250713.0.tar.gz"
  version "p6.2.20250713.0"
  sha256 "d0054c365c35c0cea853df39c050776923cd1896cc561ee16190919a461ffb0f"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fcc0d50f8df27ed86ac8f3776539ec6ca3288d2630dcb794f089ab2baa10956e"
    sha256 cellar: :any,                 arm64_sonoma:  "a12d5d0198262b6469b99328822e825cd37a70a3387dd27a74f7954b588e4220"
    sha256 cellar: :any,                 arm64_ventura: "b2249ba971b2c6e15f9fa9457b8200d7427938cc93d29ccf726743a9f592fe4c"
    sha256 cellar: :any,                 sonoma:        "de3cbaed045efb370bc204198be012b34c97f2bf66c7d770ae70bf6d3583fd8e"
    sha256 cellar: :any,                 ventura:       "a19b0c406f2d688b0dde7e94fb82a4315662bcc9c069bbef4d08d3aa031bce6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66af0731b4ed58544db7b42a91027a36ac801f95f46914e2a8402c8349834093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cf4fb45a0c2bbacbec3cc5f0bdf6007a294c0431cd970b0796994ff50d83a91"
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
