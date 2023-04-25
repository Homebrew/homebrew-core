class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230423.0.tar.gz"
  version "p6.0.20230423.0"
  sha256 "1873bb5b9369d4cfa60d503e303b3521602084ea5e79826669086dac9f60381b"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "573d206bf36db5f86fe3e28eab33f85c5dbf97ae5eb15ec85feeb37ef7fa6bf3"
    sha256 cellar: :any,                 arm64_monterey: "cb955dc9e66e87469864a6fee7be3e80ee55e0641479b69fea9a023c5313bb04"
    sha256 cellar: :any,                 arm64_big_sur:  "1498be1802845801febd107662c6f36436f4eaa444c21bdba6f9295429147316"
    sha256 cellar: :any,                 ventura:        "55a097c3417fe71dfc430a411ae7c2799ec3917d15f7b05a1e993d7dc0d3f8c6"
    sha256 cellar: :any,                 monterey:       "d458467da1c7dbe5fe538661e3b01a305c0677398fb51cbc8f98be4ae16348d4"
    sha256 cellar: :any,                 big_sur:        "36de602bd15107a614ea0b9cac87f0f0fb1b00c031033ca8d2a8afa244782602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd95cecbc42ef9033aa45c20c1b65ca4cd76edc75d2c460bde45cce96ff54cdd"
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
