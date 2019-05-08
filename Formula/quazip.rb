class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/0.7.6.tar.gz"
  sha256 "4118a830a375a81211956611cc34b1b5b4ddc108c126287b91b40c2493046b70"

  bottle do
    cellar :any
    sha256 "5d64d056c2e0a87dc620e08794bb72644204e76cff27de880ae13aa3bcb03e6b" => :mojave
    sha256 "d01af428e7233848added776030177a1bde945b10c23efd7df9dc5494f2c85e5" => :high_sierra
    sha256 "82ebc6dcba2d566ded855c9bdba360b9c43fe10af04b58eaf90a84634c79236f" => :sierra
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
