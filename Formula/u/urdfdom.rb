class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/refs/tags/4.0.1.tar.gz"
  sha256 "46b122c922f44ec32674a56e16fd4b5d068b53265898cbea2c3e1939ecccc62a"
  license "BSD-3-Clause"

  # Upstream uses Git tags (e.g. `1.0.0`) to indicate a new version. They
  # created a few releases on GitHub in the past but now they simply use tags.
  # See: https://github.com/Homebrew/homebrew-core/pull/158963#issuecomment-1879185279
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9c585056b45fa2d64da4613371f508b31ad4611f6510c7fe4f90ead4586fbfd"
    sha256 cellar: :any,                 arm64_sonoma:  "2fc91d9d915c001a4bb09644ed81c3826da2bf2ac9c28c344d39f1bc68c635d5"
    sha256 cellar: :any,                 arm64_ventura: "dd66ef35d29fcb96739777b2861277b7f26aa4300595d6c32d52a391c80a575b"
    sha256 cellar: :any,                 sonoma:        "0c1cfbccf4ec391988a01790b5bc2c2d50d2335f74c55599772465c13e6f0505"
    sha256 cellar: :any,                 ventura:       "fc7e201c27e4dff5f55208e03489194374f0b237b09cf4151561fb172e9b60f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3c2301cc4856402689959e4d995486c4c1b754a4fe3ca18128b2a202a986669"
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
