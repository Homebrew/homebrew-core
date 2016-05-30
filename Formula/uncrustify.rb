class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "http://uncrustify.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uncrustify/uncrustify/uncrustify-0.63/uncrustify-0.63.tar.gz"
  sha256 "dffbb1341a8d208e0c76b65209750e34e75b29c5a0e9a5d5a943df58bfdc2ae3"

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
