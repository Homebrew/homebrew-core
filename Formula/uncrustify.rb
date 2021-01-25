class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.72.0.tar.gz"
  sha256 "d6fff70bc7823fac4c77013055333b79a4839909094e8eee8a14ee8f1777374e"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee6e6b6d193ed163cd8365382bc56dd621f5c8f6c3776f52e4b0b2aeb1b90329" => :big_sur
    sha256 "327603c90e291b6f9f8c5bf837bfe4f22295cdf18dc397e012537eab2e7ca9b2" => :arm64_big_sur
    sha256 "c22df6af4af60a023f95f2cdce327fffe740264e44382e5bcd97e6ea9245bdb7" => :catalina
    sha256 "3340dd41ba1ad700ba8014225ac005c9a171d16b990ff275257f9c4f30097861" => :mojave
    sha256 "2af96b34e949ec3034f0c66c90918ac69b6b3f312e32ce4c27b0dfe158bfef40" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
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
