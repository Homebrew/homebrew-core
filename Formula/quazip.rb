class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "http://quazip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/quazip/quazip/0.7.2/quazip-0.7.2.tar.gz"
  sha256 "91d827fbcafd099ae814cc18a8dd3bb709da6b8a27c918ee1c6c03b3f29440f4"
  revision 1

  bottle do
    cellar :any
    sha256 "bbd2e529a171051af76d35c9a238966b8c6fa777c35eb82088b36ac21a78dacf" => :sierra
    sha256 "bbd2e529a171051af76d35c9a238966b8c6fa777c35eb82088b36ac21a78dacf" => :el_capitan
    sha256 "32533fbd39bb6275b884099e1ef4647185ced58ac21fbd88f4f0cd49ebec93be" => :yosemite
  end

  depends_on "qt5"

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

    system "#{Formula["qt5"].bin}/qmake", "test.pro"
    system "make"
    assert File.exist?("test"), "test output file does not exist!"
    system "./test"
  end
end
