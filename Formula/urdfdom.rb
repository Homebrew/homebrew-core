class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/1.0.4.tar.gz"
  sha256 "8f3d56b0cbc4b84436d8baf4c8346cd2ee7ffb257bba5ddd9892c41bf516edc4"
  revision 2

  bottle do
    cellar :any
    sha256 "5828c253e91dee4ee57acd08ea0ac0a524543dbf23a8da2df1c95193d0e0345c" => :catalina
    sha256 "5b8413b4cd6468a324bc73335655e3a5a6add6e2c7a092339333f717ef3ba414" => :mojave
    sha256 "517db80473a63c059e85a6f49ec0bc18af579351b15fb0f3c83cc5720f7d19d1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "console_bridge"
  depends_on "tinyxml"
  depends_on "urdfdom_headers"

  patch do
    # Fix for finding console_bridge 1.0
    url "https://github.com/ros/urdfdom/commit/6faba176d41cf39114785a3e029013f941ed5a0e.diff?full_index=1"
    sha256 "f914442c1a3197cd8ac926fd2f7ef1a61f81f54b701515b87f7ced7a59078eb4"
  end

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
