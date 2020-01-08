class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/1.0.3.tar.gz"
  sha256 "839d939fbd91d115f928a6e02334638829c58d9c8ea2f81bfa3faffd233c154c"

  bottle do
    cellar :any
    sha256 "124c7475dc74116d0185194354dbe12ab0a383592a81c5617e62c4065155b7cd" => :catalina
    sha256 "263f8b75de2465c83b527ea27fe6fdc2687d14571114f575c433a3316f2b9524" => :mojave
    sha256 "736c863207d6de888b32645de4a68a32776e0011d115ca51feb98bf066e9493f" => :high_sierra
    sha256 "fe30973514c5c9f9a6484b98ae3b36ae98fc5b0bfdadf7d8cfcd889391f68a72" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "console_bridge"
  depends_on "tinyxml"
  depends_on "urdfdom_headers"

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <string>
      #include <urdf_parser/urdf_parser.h>
      int main() {
        std::string xml_string =
          "<robot name='testRobot'>"
          "  <link name='link_0'>  "
          "  </link>               "
          "</robot>                ";
        urdf::parseURDF(xml_string);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lurdfdom_world", "-std=c++11",
                    "-o", "test"
    system "./test"
  end
end
