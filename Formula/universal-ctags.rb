class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20211212.0.tar.gz"
  version "p5.9.20211212.0"
  sha256 "5fd0b3e4d7f0fd7f3e8d78d95cd7681e155a484445c71ce4afd66c86fb74773e"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ed4a69c79bb23a75b8781ddb46d39b0a8a8c96d5826075c0b75620ac75f8a766"
    sha256 cellar: :any,                 arm64_big_sur:  "544b1cc4f80a6fd9b3c33c46572a13f8fe20a938658f749b7f3c5706d04ee4ce"
    sha256 cellar: :any,                 monterey:       "07ba822f338b73fa6ff46c904c3a799d833d230c960e29169d6a61bec993b8d6"
    sha256 cellar: :any,                 big_sur:        "685e2422277feb308153e880b820cb5a6d138912e2fe887902354efa58465e45"
    sha256 cellar: :any,                 catalina:       "96c3ee8de08dc10974c1e0846bc9af14bfa3a7f3b79a65f3ebba2e81d6c907f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fddb05ebd251ac9a2e9c7aca5bd5c4910c8cf490d7ef3d8c1d1538c97a400a36"
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
