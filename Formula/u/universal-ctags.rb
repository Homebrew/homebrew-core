class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/releases/download/v6.2.1/universal-ctags-6.2.1.tar.gz"
  sha256 "2c63efe9e0e083dc50e6fdd8c5414781cc8873d8c8940cf553c01870ed962f8c"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04462c7b1fad942219dd2eabd936b74d882663299c9463774cb0f903ddb1aaa0"
    sha256 cellar: :any,                 arm64_sequoia: "25fe4f06afaa90e2ae0a9ff5db65907d7b10661277d1a059fc4acafdf903ec5c"
    sha256 cellar: :any,                 arm64_sonoma:  "abac0bf20153b9a1cbdccf1f95ab8fee907adf4607873b5b63fda6758d47edd6"
    sha256 cellar: :any,                 sonoma:        "b0b3270037bd744571517a734136213474ba9aaa304977137d4f78cc35490d62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4529f5ea92739c6a603e9d8a301e7f2fdd5c0ee07aeeeb39f9852f50d805de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2970ae4a8b7332e017abf1f4e0286864ef48ca5f6f7f0c93224347f26c05458a"
  end

  head do
    url "https://github.com/universal-ctags/ctags.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "both install `ctags` binaries"

  def install
    system "./autogen.sh" if build.head?
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
