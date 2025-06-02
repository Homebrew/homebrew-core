class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/refs/tags/5.0.0.tar.gz"
  sha256 "31ce32c68312df5c344c5b5a5d4337ca5068aa405634bd2c5ec43be4486b831b"
  license "BSD-3-Clause"

  # Upstream uses Git tags (e.g. `1.0.0`) to indicate a new version. They
  # created a few releases on GitHub in the past but now they simply use tags.
  # See: https://github.com/Homebrew/homebrew-core/pull/158963#issuecomment-1879185279
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ee777c8a0e4e3230790d549ae85b001fdb570bc43ae5e4344e012b6e9b29505"
    sha256 cellar: :any,                 arm64_sonoma:  "00fa20fc9a6eaeb50d88d5f760a037e672d55ababe644e70eb3d14c61a9f98c1"
    sha256 cellar: :any,                 arm64_ventura: "746ad363e1f35643ba0008b695ce493b8e35af0b78528698b14d9d3ffeebf593"
    sha256 cellar: :any,                 sonoma:        "28547a88558e5b2ec2862227dcdb95ed5eeabf2b66123ad4f7f80c6f8f3c2f67"
    sha256 cellar: :any,                 ventura:       "1d33ef4ff5c0c26164d365187990bbd0de0160958c33b2b9831ba8382f301713"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9923916cb7e92243fb829f6675fcad95fb57fbb43452551ec38809305b1d5154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0676acc9256763cd404e5563c69526ea9894f07417ff64d4247964fa993ec99e"
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
