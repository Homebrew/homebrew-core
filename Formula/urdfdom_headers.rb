class UrdfdomHeaders < Formula
  desc "Headers for Unified Robot Description Format (URDF) parsers"
  homepage "https://wiki.ros.org/urdfdom_headers/"
  url "https://github.com/ros/urdfdom_headers/archive/1.1.0.tar.gz"
  sha256 "01b91c2f7cb42b0033cbdf559684a60001f9927e5d0a5a3682a344cc354f1d39"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7af8770bcbebfab71cb7921651eae92d0d57a1e4176842c0a63dc7fc64715e8c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test

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
    system ENV.cxx, shell_output("pkg-config --cflags urdfdom_headers").chomp, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
