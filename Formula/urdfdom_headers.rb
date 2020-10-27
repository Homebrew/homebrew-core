class UrdfdomHeaders < Formula
  desc "Headers for Unified Robot Description Format (URDF) parsers"
  homepage "https://wiki.ros.org/urdfdom_headers/"
  url "https://github.com/ros/urdfdom_headers/archive/1.0.5.tar.gz"
  sha256 "76a68657c38e54bb45bddc4bd7d823a3b04edcd08064a56d8e7d46b9912035ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6840c3177042a718ae29bc8238e5ec20dbcde4f9269b3042f8eed1a2aa6292c" => :catalina
    sha256 "c6840c3177042a718ae29bc8238e5ec20dbcde4f9269b3042f8eed1a2aa6292c" => :mojave
    sha256 "c6840c3177042a718ae29bc8238e5ec20dbcde4f9269b3042f8eed1a2aa6292c" => :high_sierra
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
