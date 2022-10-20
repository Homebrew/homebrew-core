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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "0119d332e408fcfc79bba65b7f2ead332e309c101d48eeb9587ea9eb3bcb3053"
    sha256 cellar: :any,                 arm64_big_sur:  "c36ca6d6feeb0bdc9b5a53ab272a78cd5a3e5902fd13bcc7b5ea1edc743a35d7"
    sha256 cellar: :any,                 monterey:       "71070ede6f57db3c5140144fc0d18ed71d7c159f14b5c7834d4cec7f33fbe8e1"
    sha256 cellar: :any,                 big_sur:        "da4484607e08e23f56cd1f38df0af861c8fa15de55e128f1c5baf264f58899f6"
    sha256 cellar: :any,                 catalina:       "9fca3bc7b89402d176cc2ccd392c49acf25274c170c1fd8a26c3b579b134ad30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b28fad24d464ee6921378d942e409122ba303c642bcdab05e46e50f370e6f6f0"
  end

  depends_on "cmake" => :build
  depends_on "console_bridge"
  depends_on "tinyxml"
  depends_on "urdfdom_headers"

  def install
    ENV.cxx11
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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

    (testpath/"test.xml").write <<~EOS
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
    EOS

    system "#{bin}/check_urdf", testpath/"test.xml"
  end
end
