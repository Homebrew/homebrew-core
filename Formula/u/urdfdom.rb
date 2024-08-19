class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/refs/tags/4.0.0.tar.gz"
  sha256 "9848d106dc88dc0b907d5667c09da3ca53241fbcf17e982d8c234fe3e0d6ddcc"
  license "BSD-3-Clause"
  revision 1

  # Upstream uses Git tags (e.g. `1.0.0`) to indicate a new version. They
  # created a few releases on GitHub in the past but now they simply use tags.
  # See: https://github.com/Homebrew/homebrew-core/pull/158963#issuecomment-1879185279
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "23ef43afad8dc543b4160fce22b692cfcbf4cb720412dbc43116eb23a56ef6c9"
    sha256 cellar: :any,                 arm64_ventura:  "662d33ada7489c772466fe72ab7efaf60aad3e05b8e083ef7e5519e948304287"
    sha256 cellar: :any,                 arm64_monterey: "93c2592a0fe16506c95af1cf603e1011ac1d0ee49cb620ed9e2605a2af9d8589"
    sha256 cellar: :any,                 sonoma:         "52347646204fb3ce2334a627162a120fcabbeb210f1663b3b4d0e2a5daa7246e"
    sha256 cellar: :any,                 ventura:        "af0bd85409870501150192c1972fcff204702f82facb6a03ed8c149c05e2cad4"
    sha256 cellar: :any,                 monterey:       "cd1914b68c197c8b4f67274a2d67d134fcc281404bb6809d6280147f6a8954fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0ed65ec038f541dcb4554b4e6f663efd8aca05e27fb6cab4146cf4a2928a3b9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
  depends_on "console_bridge"
  depends_on "tinyxml2"
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
    system ENV.cxx, "test.cpp", *shell_output("pkg-config --cflags urdfdom").chomp.split,
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

    system bin/"check_urdf", testpath/"test.xml"
  end
end
