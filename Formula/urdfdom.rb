class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/1.0.0.tar.gz"
  sha256 "243ea925d434ebde0f9dee35ee5615ecc2c16151834713a01f85b97ac25991e1"
  revision 1

  bottle do
    cellar :any
    sha256 "0d9948da11cd8e1d0f5d90ce33362d6bf8ca24cbe412c0673b5d23790abc8148" => :mojave
    sha256 "ffe532a4d96689d515b46ac589afbb9e071a463250e65bbd9453d2db7e8e9eee" => :high_sierra
    sha256 "8d4a25f145f4522f14b5085fdc7c3f6182237ee472a1b51e31e0093371f68acd" => :sierra
    sha256 "03be42a92fe4a40b03ff648b45393ad6ca4db533286bdff32e3837862a326a1e" => :el_capitan
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
