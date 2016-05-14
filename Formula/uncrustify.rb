class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "http://uncrustify.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uncrustify/uncrustify/uncrustify-0.62/uncrustify-0.62.tar.gz"
  sha256 "5d19307aa75f904159385d83ef7e6a605c0148ce5da3a2d9366e34867c28385a"

  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "621681a09183609e57ec49b5c881fc1e13869fce159367f7c99bca89bdaa6581" => :el_capitan
    sha256 "d8f488e654b50139cfa9aa1bdab9eac1d3f052304db89134fdddc32ed882a7e4" => :yosemite
    sha256 "ef21d9647596c71d162bb35fca669f977420c8dd1d7ad6ee6f7c4aff161d5be4" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"t.c").write <<-EOS.undent
      #include <stdio.h>
      int main(void) {return 0;}
    EOS
    expected = <<-EOS.undent
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    EOS

    system "#{bin}/uncrustify", "-c", "#{pkgshare}/defaults.cfg", "t.c"
    assert_equal expected, File.read("#{testpath}/t.c.uncrustify")
  end
end
