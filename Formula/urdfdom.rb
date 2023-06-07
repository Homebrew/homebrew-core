class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/3.0.0.tar.gz"
  sha256 "3c780132d9a0331eb2116ea5dac6fa53ad2af86cb09f37258c34febf526d52b4"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "69e286e3dbf2faea6d2a48cc31b78a7ad0088515625117c1cc8f34b80309924d"
    sha256 cellar: :any,                 arm64_monterey: "27b8cd81640a8de4e9ffb343487a44ba9984f699d3c27f7ff9bd595e25e21d6c"
    sha256 cellar: :any,                 arm64_big_sur:  "0ca970f6f985415e1e8af91a36ba0fc1d7b7170ec9235060e8d3973bd9ec4147"
    sha256 cellar: :any,                 ventura:        "1f13a06d147840608fea0deaefd889e7eafb2a19c0c5bd2db50ffbe1d53a956d"
    sha256 cellar: :any,                 monterey:       "43be2b4453f1a4f782bbc99ad5347a021825bf88ed8882500def4a0bc018a3c6"
    sha256 cellar: :any,                 big_sur:        "fce2480ab751c0b9334f23961debbca834013c4ab8cae0aa117b43767f8e1d94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a303920e61aa553fc7f71c0380d2bb2693e0f6aca0c0eee199768a5d6bdac9e3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
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
    system ENV.cxx, "test.cpp", shell_output("pkg-config --cflags urdfdom_headers").chomp,
                    "-L#{lib}", "-lurdfdom_world",
                    "-std=c++11", "-o", "test"
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
