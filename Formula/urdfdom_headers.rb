class UrdfdomHeaders < Formula
  desc "Headers for Unified Robot Description Format (URDF) parsers"
  homepage "https://wiki.ros.org/urdfdom_headers/"
  url "https://github.com/ros/urdfdom_headers/archive/1.0.3.tar.gz"
  sha256 "b58989cba5ba413cba4caa5f0aa64dfcd724feca0309ab059761f2bfa3759edb"

  bottle do
    cellar :any_skip_relocation
    sha256 "03363b4cd2cc6fd0a84992e05f722123cde706b1d458d4d7cdcdde365edbaa8e" => :mojave
    sha256 "110d5406db175f8290aa9ad46c685be7a7e6bddd2dc45695e1b8d774c57370c2" => :high_sierra
    sha256 "110d5406db175f8290aa9ad46c685be7a7e6bddd2dc45695e1b8d774c57370c2" => :sierra
  end

  depends_on "cmake" => :build

  needs :cxx11

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
