class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20240324.0.tar.gz"
  version "p6.1.20240324.0"
  sha256 "89a47662457422a42aebdf4f4dfe15fde7d14eab719337bbe22815900179f1f4"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9064b421922bc5fd459157dd0ce6980d3220d28a945c87d1ba63d56a51e5151f"
    sha256 cellar: :any,                 arm64_ventura:  "6053627501ce9b668787441f0fb5d18dfddd959cd903333351c31c3d2a401db9"
    sha256 cellar: :any,                 arm64_monterey: "6fdb64c78afa74552e1f918c6d43377da84a04c29d1f7651303d7a84abd5c5c6"
    sha256 cellar: :any,                 sonoma:         "1bd34199973b03775299807bc9810bdc2ab78590afa68b756c504c9af2b5ab73"
    sha256 cellar: :any,                 ventura:        "43fc2f675252e49d087cd41c3520e47f763c502ddddc1577f7db58b6814b6ecc"
    sha256 cellar: :any,                 monterey:       "51a4667a8cbdff902e301e63ac3b000a18083af9d185c5e0120d58e16ecb8cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "365171fdf9b0f64f08fb1695d4d9ced8222da6b188fcb15c42170c00a33e191b"
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
