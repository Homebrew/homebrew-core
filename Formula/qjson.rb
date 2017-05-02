class Qjson < Formula
  desc "Map JSON to QVariant objects"
  homepage "https://qjson.sourceforge.io"
  url "https://github.com/flavio/qjson/archive/0.9.0.tar.gz"
  sha256 "e812617477f3c2bb990561767a4cd8b1d3803a52018d4878da302529552610d4"
  revision 1

  bottle do
    cellar :any
    sha256 "bd50e784f99285df8e70448f041c67fe1f8c79f5d6b17f130a2e3a11bc19227d" => :sierra
    sha256 "befe6eeb2426c2f698dd54999398fa569d91246d239aef3e877680902a20f945" => :el_capitan
    sha256 "f17d608977669101c13d3f57136d8d8121a0f87e26a0d7a55ee5a21659294355" => :yosemite
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
