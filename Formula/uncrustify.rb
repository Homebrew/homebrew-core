class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "http://uncrustify.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uncrustify/uncrustify/uncrustify-0.63/uncrustify-0.63.tar.gz"
  sha256 "dffbb1341a8d208e0c76b65209750e34e75b29c5a0e9a5d5a943df58bfdc2ae3"

  bottle do
    cellar :any_skip_relocation
    sha256 "387c422d75c6f1ca680cc4a0b8541dda9aeb40cd7b3fcf685efddbf1f29ea2d6" => :el_capitan
    sha256 "9e2c5d484dc6cc7a9eaa26b3b26ebeafaa9974144e43fcb6fedcae4196f0a654" => :yosemite
    sha256 "7bbc100632b13c81d2ec3ab897629f49effbb5dc76f991c4abde65566742b868" => :mavericks
  end

  head do
    url "https://github.com/uncrustify/uncrustify.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
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
