class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/v1.1.tar.gz"
  sha256 "54edce9c11371762bd4f0003c2937b5d8806a2752dd9c0fd9085e90792612ad0"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, catalina:    "fcc3c28686a10a6e8d0e95ac978c0499400e5af3364c015f6ee128d9c0fd878e"
    sha256 cellar: :any, mojave:      "b74d9a5c9d2dbc349de524bce7ae4ef45882b37e2187b065c11141d7a2056953"
    sha256 cellar: :any, high_sierra: "632c10f191326e2afc006c9a065f40af0f5ab8d6b562b4013ecdf77e79ed1eaf"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt@5"

  def install
    system "cmake", ".", "-DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_lib}", *std_cmake_args
    system "make"
    system "make", "install"

    cd include do
      include.install_symlink "QuaZip-Qt#{Formula["qt@5"].version.major}-#{version}/quazip" => "quazip"
    end
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lquazip#{version.major}-qt#{Formula["qt@5"].version.major}
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <quazip/quazip.h>
      int main() {
        QuaZip zip;
        return 0;
      }
    EOS

    system "#{Formula["qt@5"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
