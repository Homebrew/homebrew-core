class UrdfdomHeaders < Formula
  desc "Headers for Unified Robot Description Format (URDF) parsers"
  homepage "https://wiki.ros.org/urdfdom_headers/"
  url "https://github.com/ros/urdfdom_headers/archive/1.0.5.tar.gz"
  sha256 "76a68657c38e54bb45bddc4bd7d823a3b04edcd08064a56d8e7d46b9912035ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "b46332ee7c9d7efb6a9ea01b885a8342d77899d9ec92d8bc55893d70aebbfadd" => :catalina
    sha256 "a39d21ec585536f3d512f7be56ea1e0139aacaea9875847c758a850067f6309f" => :mojave
    sha256 "a39d21ec585536f3d512f7be56ea1e0139aacaea9875847c758a850067f6309f" => :high_sierra
    sha256 "14f2851e93c174aa2632d7e69abb9522e52a2b8d040f3d4826c8c15517150525" => :sierra
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
