class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/v0.9.1.tar.gz"
  sha256 "5d36b745cb94da440432690050e6db45b99b477cfe9bc3b82fd1a9d36fff95f5"

  bottle do
    cellar :any
    sha256 "c87649c7ed9ef2b01e68f1ff6e3b3c5b4450a75bc51b3a94ef658947bf8e06e0" => :catalina
    sha256 "63eb1db37180ebf9b7a17e18f7e473e44e10418a3382e6e3df35afe365cff76c" => :mojave
    sha256 "fac8619159e8afe5ba7605090480f1753fc2e17a145911a6f21c0985dade5509" => :high_sierra
  end

  depends_on :xcode => :build
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
