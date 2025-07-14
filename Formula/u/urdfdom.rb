class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/refs/tags/5.0.2.tar.gz"
  sha256 "f929a33ec6171a57d4ff7d4c0eff6fb79d4725c279189d4f4c8806c4aa4e71ac"
  license "BSD-3-Clause"

  # Upstream uses Git tags (e.g. `1.0.0`) to indicate a new version. They
  # created a few releases on GitHub in the past but now they simply use tags.
  # See: https://github.com/Homebrew/homebrew-core/pull/158963#issuecomment-1879185279
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "756fda4ead0dd187f6ed44bdbdf1d03142a4088d334e9d27bfe1ae1b6d0f2cfa"
    sha256 cellar: :any,                 arm64_sonoma:  "08e6d3e29fb2072ade8ff174827d0c59ee5c28bcf288e8da09a56846ead4998d"
    sha256 cellar: :any,                 arm64_ventura: "07a35187641e8a0a27266ead0227892a37e8f847ec580877c513382cca1b740c"
    sha256 cellar: :any,                 sonoma:        "3d2f693b70cc2f54f6f9135577865cad22d5231197058020586bb98137e525e0"
    sha256 cellar: :any,                 ventura:       "f1e57f3dd834b113e765beaa5f26e187647f5ecb34445e761fa5028614fb3d17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c970633d691e7638e3d19fb153f405b76ed940371558199f682b71cca5043e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df20fa90b221d69a837117f743067ba079e9d414d441aedf1edf1a3ec68169dc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "console_bridge"
  depends_on "tinyxml2"
  depends_on "urdfdom_headers"

  def install
    ENV.cxx11
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", *shell_output("pkg-config --cflags urdfdom").chomp.split,
                    "-L#{lib}", "-lurdfdom_world",
                    "-std=c++11", "-o", "test"
    system "./test"

    (testpath/"test.xml").write <<~XML
      <robot name="test">
        <joint name="j1" type="fixed">
          <parent link="l1"/>
          <child link="l2"/>
        </joint>
        <joint name="j2" type="fixed">
          <parent link="l1"/>
          <child link="l2"/>
        </joint>
        <link name="l1">
          <visual>
            <geometry>
              <sphere radius="1.349"/>
            </geometry>
            <material name="">
              <color rgba="1.0 0.65 0.0 0.01" />
            </material>
          </visual>
          <inertial>
            <mass value="8.4396"/>
            <inertia ixx="0.087" ixy="0.14" ixz="0.912" iyy="0.763" iyz="0.0012" izz="0.908"/>
          </inertial>
        </link>
        <link name="l2">
          <visual>
            <geometry>
              <cylinder radius="3.349" length="7.5490"/>
            </geometry>
            <material name="red ish">
              <color rgba="1 0.0001 0.0 1" />
            </material>
          </visual>
        </link>
      </robot>
    XML

    system bin/"check_urdf", testpath/"test.xml"
  end
end
