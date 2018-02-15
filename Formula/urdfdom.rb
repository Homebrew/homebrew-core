class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/1.0.0.tar.gz"
  sha256 "243ea925d434ebde0f9dee35ee5615ecc2c16151834713a01f85b97ac25991e1"
  revision 1

  bottle do
    cellar :any
    sha256 "a7ab2c2af35c514aeaf1f8430ae0b006c202168702bad2e097d41b0a457c677e" => :high_sierra
    sha256 "918cea5cb5b12f5c402b30bffb202e7a647da346500879ae0a8b012185e26170" => :sierra
    sha256 "df2053f208f884bd3c05be4ea4b74cfe8b38b2b48e9ecd16946185d92fbc7a24" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "console_bridge"
  depends_on "tinyxml"
  depends_on "urdfdom_headers"

  needs :cxx11

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
