class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/refs/tags/5.1.0.tar.gz"
  sha256 "096478dc889fda2b375184304bd2511d4f33182ecd05732284c15978e2ef5d47"
  license "BSD-3-Clause"
  compatibility_version 1

  # Upstream uses Git tags (e.g. `1.0.0`) to indicate a new version. They
  # created a few releases on GitHub in the past but now they simply use tags.
  # See: https://github.com/Homebrew/homebrew-core/pull/158963#issuecomment-1879185279
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e7d801dcf69b7583b0937419e403febbd75e7462e4f3626671d95e57dfde346"
    sha256 cellar: :any,                 arm64_sequoia: "16c29cecd6d8318f838bd88b20fcc189fb39be46a2219c48affad7a73f39d688"
    sha256 cellar: :any,                 arm64_sonoma:  "1c8f5ab5fc78f84581cb6094b286289bde80392f573b8d0a7744b78d9a49e042"
    sha256 cellar: :any,                 sonoma:        "3b4bb1f78375fa6a416d597238a11892f4a1fdd8487736cab2c452654d41c9c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b980bae0bc61095fc6f6ec1d0f9ed0614c09c2965dceacbd126d05bae18abfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "567dfc0d2fefa4e90f8915abe3e142f5f2dd826b5a435915a417a4a5be98e40f"
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
