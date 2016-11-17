class Qjson < Formula
  desc "Map JSON to QVariant objects"
  homepage "https://github.com/flavio/qjson"
  url "https://github.com/flavio/qjson/archive/0.8.1.tar.gz"
  sha256 "920c94166cb91b1cf11c7d2745bdbcc8c0ea82411ca7b3732ce0b00ee2d56e98"
  revision 1
  head "https://github.com/flavio/qjson.git"

  bottle do
    cellar :any
    revision 2
    sha256 "4d47edace9872cd7cb267ca6e77c7f7d55400918cbdc57d45e4ee5d12087f4da" => :el_capitan
    sha256 "a505ef97e0a0a3e05013ef1aa641af1104dedb363ff75c7d23b2c3dee5299649" => :yosemite
    sha256 "2563c0f4d42e92136279434e9e73201b3117993d2eaa949359dab9c148d71710" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "qt5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <qjson/parser.h>
      int main() {
        QJson::Parser parser;
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lqjson",
           testpath/"test.cpp", "-o", testpath/"test"
    system "./test"
  end
end
