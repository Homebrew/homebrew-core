class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20231001.0.tar.gz"
  version "p6.0.20231001.0"
  sha256 "785d2c172c9ff88ccfdb43bad64c316808c80321d8c79e85cf394df5dd3bf160"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e0416191ab0a33256ee7e7d36833be7abf1c2bab4269f378a4f91c6950fad36c"
    sha256 cellar: :any,                 arm64_ventura:  "a5ad11f06dbab7f827ffff5f50625ab14e0b6b837f471e414962f358c5c687d3"
    sha256 cellar: :any,                 arm64_monterey: "12376b0ed5f82a7fe3bb186112259a20e8ba5f1bd4cee6518aab72005f6ecf48"
    sha256 cellar: :any,                 sonoma:         "e7acb16d126dbef0fdabb650b09d7075b6bb77796bbfece29d89d1f15e634753"
    sha256 cellar: :any,                 ventura:        "ffa95a2c0e683c444111e415b173b96d720df117c8a60c0cce538a0f2e0d0701"
    sha256 cellar: :any,                 monterey:       "171aa357e0c93e478333ae86a3cf48e89077a58fa815611e70ae043c1bbe9b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab44e1443930961b7b7ea6ddd4622b6afdd73545c3a4dfea7b29c07ed8a74e4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
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
