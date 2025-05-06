class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/refs/tags/4.0.1.tar.gz"
  sha256 "46b122c922f44ec32674a56e16fd4b5d068b53265898cbea2c3e1939ecccc62a"
  license "BSD-3-Clause"
  revision 2

  # Upstream uses Git tags (e.g. `1.0.0`) to indicate a new version. They
  # created a few releases on GitHub in the past but now they simply use tags.
  # See: https://github.com/Homebrew/homebrew-core/pull/158963#issuecomment-1879185279
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3ed3dde9c2b78c7f927c4c540a3a90d16985fd6dfc7b94050ea2be6d74c61859"
    sha256 cellar: :any,                 arm64_sonoma:  "ca18c2992d4c3bcdd0a4e9f726adea18edcae94cccf6cc269ffd0330e80f15a6"
    sha256 cellar: :any,                 arm64_ventura: "e32a669ed439235b13bb6203a6f3066eeab3d553e831a03b3fb93d0dcdb10687"
    sha256 cellar: :any,                 sonoma:        "ce64f9e5a7d6a4040adb4a1d312033c99d1209b348ecf5548578b92a0ceb02b0"
    sha256 cellar: :any,                 ventura:       "e8cae39e8878cc446dd0a6a09cf2b91345d1220bf5129465d91ae95f04e6d4d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0700b581db89ca6381c9df8704e2cef2dc93652d2ae9d2a8a5354eb39491fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4790d12c1dc93c70540a0b434447b967580c10303ba8cfbbc7416d15a6f19562"
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
