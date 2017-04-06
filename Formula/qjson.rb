class Qjson < Formula
  desc "Map JSON to QVariant objects"
  homepage "https://qjson.sourceforge.io"
  url "https://github.com/flavio/qjson/archive/0.9.0.tar.gz"
  sha256 "e812617477f3c2bb990561767a4cd8b1d3803a52018d4878da302529552610d4"
  revision 1

  bottle do
    cellar :any
    sha256 "cd843f07c21db43f1d38a1651b371a53ccd4c44975c08d56db0d6a4284c9d587" => :sierra
    sha256 "89d3c3cc1ce2d45b37a6c8001c047b46135111419c27e27377a0158fd0685ebf" => :el_capitan
    sha256 "4cabfd9f2086b49b21bac869d061b0bd467f8cbef378f16f23c4b3019f655c05" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "qt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <qjson-qt5/parser.h>
      int main() {
        QJson::Parser parser;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lqjson-qt5",
                    "-I#{Formula["qt"].opt_include}",
                    "-F#{Formula["qt"].opt_lib}", "-framework", "QtCore"
    system "./test"
  end
end
