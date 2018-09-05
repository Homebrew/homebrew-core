class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://quazip.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quazip/quazip/0.7.3/quazip-0.7.3.tar.gz"
  sha256 "2ad4f354746e8260d46036cde1496c223ec79765041ea28eb920ced015e269b5"
  revision 1

  bottle do
    cellar :any
    sha256 "b13bd6ecd6f2a2272146f0116db139338e734d094df442e695b9e4520a3d1ac4" => :mojave
    sha256 "907e72c7b9ee1af624c684c960925b3227409d3c95324bfc00aef2ad6384d22c" => :high_sierra
    sha256 "9ec688664e0354803611744d1aaeec073cf0912762652be352404ac1c1fadfb4" => :sierra
    sha256 "ce3454f5f7c5c8083df617ec63ccaf7291091da544287719573fc2c3dbb744c6" => :el_capitan
    sha256 "dc296670c3c7bd52c825bb545132df0731c274af47f44d8ecefc53eda3c2065c" => :yosemite
  end

  depends_on "qt"

  def install
    system "qmake", "quazip.pro", "-config", "release",
                    "PREFIX=#{prefix}", "LIBS+=-lz"
    system "make", "install"
  end

  test do
    (testpath/"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lquazip
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <quazip/quazip.h>
      int main() {
        QuaZip zip;
        return 0;
      }
    EOS

    system "#{Formula["qt"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
