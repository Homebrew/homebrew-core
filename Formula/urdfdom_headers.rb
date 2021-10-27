class UrdfdomHeaders < Formula
  desc "Headers for Unified Robot Description Format (URDF) parsers"
  homepage "https://wiki.ros.org/urdfdom_headers/"
  url "https://github.com/ros/urdfdom_headers/archive/1.0.5.tar.gz"
  sha256 "76a68657c38e54bb45bddc4bd7d823a3b04edcd08064a56d8e7d46b9912035ac"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d1960994a18f178a7ff7b5f6a0b479bbd5abcba370fb72b816fd99ff044283c"
    sha256 cellar: :any_skip_relocation, big_sur:       "45e38439bb14220663e856c3db0017987adfe1765c815344c38f404cf49849a6"
    sha256 cellar: :any_skip_relocation, catalina:      "c6840c3177042a718ae29bc8238e5ec20dbcde4f9269b3042f8eed1a2aa6292c"
    sha256 cellar: :any_skip_relocation, mojave:        "c6840c3177042a718ae29bc8238e5ec20dbcde4f9269b3042f8eed1a2aa6292c"
    sha256 cellar: :any_skip_relocation, high_sierra:   "c6840c3177042a718ae29bc8238e5ec20dbcde4f9269b3042f8eed1a2aa6292c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9b714415e5939d4ee8c7cbee3494f3f84eb06def8635f8d579dff740af05d6f"
    sha256 cellar: :any_skip_relocation, all:           "c851880d554db90688c10eb68a1ea22051f0bb7453667590aa61f9821983bedb"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <urdf_model/pose.h>
      int main() {
        double quat[4];
        urdf::Rotation rot;
        rot.getQuaternion(quat[0], quat[1], quat[2], quat[3]);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
