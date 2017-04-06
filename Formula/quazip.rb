class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://quazip.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quazip/quazip/0.7.3/quazip-0.7.3.tar.gz"
  sha256 "2ad4f354746e8260d46036cde1496c223ec79765041ea28eb920ced015e269b5"
  revision 1

  bottle do
    cellar :any
    sha256 "00ea751dca58a09560c21149298df7c320613c589b034e17830cf8ee2520f3df" => :sierra
    sha256 "857651ea50693f66e8760c83869ded6980920547a6097c3ac98158cd18ee099f" => :el_capitan
    sha256 "d10b2676efebaeedc6d51f2a1b18cc638207c866d7ba657d62fb0a09123c4247" => :yosemite
  end

  depends_on "qt"

  def install
    system "qmake", "quazip.pro", "-config", "release",
                    "PREFIX=#{prefix}", "LIBS+=-lz"
    system "make", "install"
  end

  test do
    (testpath/"test.pro").write <<-EOS.undent
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lquazip
    EOS

    (testpath/"test.cpp").write <<-EOS.undent
      #include <quazip/quazip.h>
      int main() {
        QuaZip zip;
        return 0;
      }
    EOS

    system "#{Formula["qt"].bin}/qmake", "test.pro"
    system "make"
    assert File.exist?("test"), "test output file does not exist!"
    system "./test"
  end
end
