class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/6.0.0.tar.gz"
  sha256 "9444ba6322267110b4aca61cbe37d5dcab040344b5c97d0b36c119aa61319b0f"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    cellar :any
    sha256 "944d60c2909c15a3137d7701ebc6ce9206b9c071e63999a6e0c5bdb0c6dce9ea" => :high_sierra
    sha256 "2495e81e88b0adbdec85e4fe45ca866494ec40443877f7877cbff4abf265c7d6" => :sierra
    sha256 "49640c4f705ee211d4607a84bfeb5ce1c8af60df64d9259e2253f7fdad57fb46" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tinyxml2.h>
      int main() {
        tinyxml2::XMLDocument doc (false);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-ltinyxml2", "-o", "test"
    system "./test"
  end
end
