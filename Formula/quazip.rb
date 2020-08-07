class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/v0.9.1.tar.gz"
  sha256 "5d36b745cb94da440432690050e6db45b99b477cfe9bc3b82fd1a9d36fff95f5"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "fcc3c28686a10a6e8d0e95ac978c0499400e5af3364c015f6ee128d9c0fd878e" => :catalina
    sha256 "b74d9a5c9d2dbc349de524bce7ae4ef45882b37e2187b065c11141d7a2056953" => :mojave
    sha256 "632c10f191326e2afc006c9a065f40af0f5ab8d6b562b4013ecdf77e79ed1eaf" => :high_sierra
  end

  depends_on xcode: :build
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
