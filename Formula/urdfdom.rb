class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/3.0.0.tar.gz"
  sha256 "3c780132d9a0331eb2116ea5dac6fa53ad2af86cb09f37258c34febf526d52b4"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ced2cb8a17221d58fee32a3b5ecedaeef6caf43c4a721b1a543a1db2e9a1d30f"
    sha256 cellar: :any,                 arm64_big_sur:  "144123d35146a73b2faa6a41d05d5660efbc35d8d19b23bffad4bbe4335a4f26"
    sha256 cellar: :any,                 monterey:       "cbf83550cba6be1cc2ce3eaf4693872d266ba9effe2c0974581d00c1ffdd5079"
    sha256 cellar: :any,                 big_sur:        "61bdf95fadfdd5ec951efe254a57068f50037e6ee8a5f9e2a46333aca445c283"
    sha256 cellar: :any,                 catalina:       "75b9eb3c4cbc6a1f7ba49d9c664895f6b523d1c72c4a0829858e4cb85f36e5b1"
    sha256 cellar: :any,                 mojave:         "2b50fa0f77d4e0255488e1978f7550d007ac16da5caf7b74b73553673a15d0b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ac7538d7996e4e71f976f811dc4b362d40993487dca09ab13dafd4675005b58"
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
