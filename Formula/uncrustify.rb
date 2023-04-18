class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.76.0.tar.gz"
  sha256 "32e2f95485a933fc5667880f1a09a964ae83132c235bb606abbb0a659453acb3"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ba4acfdf54afafa7883864e311026846ccd119665a512e400dffed64b5d8486"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05b95d644b7c095a5ddbc54773bb024325e29e64c5188083e230c5cfb15c5a5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0ab5da87cbf8beb72eb110b73ad91526f2b1eeecfedac631e0c4fbf9a59c715"
    sha256 cellar: :any_skip_relocation, ventura:        "26be305003899221811223af07c84f627e5b403bfb93f8656e1cb251fe9e0afd"
    sha256 cellar: :any_skip_relocation, monterey:       "2d7c0e4d84531eca1c8d4075d20b5eb6e5a93487ddf45722bb6a53f4e10a6e30"
    sha256 cellar: :any_skip_relocation, big_sur:        "d29b8bfafa9f7344327644ce2450000097bf1393c6d0bfe0c1f8b3cb0d3a24ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5e5efe644b8f259fcdd6235b9f6fbcd356dc009990d2770a0de03d5e7056238"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    doc.install (buildpath/"documentation").children
  end

  test do
    (testpath/"t.c").write <<~EOS
      #include <stdio.h>
      int main(void) {return 0;}
    EOS
    expected = <<~EOS
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    EOS

    system "#{bin}/uncrustify", "-c", "#{doc}/htdocs/default.cfg", "t.c"
    assert_equal expected, File.read("#{testpath}/t.c.uncrustify")
  end
end
