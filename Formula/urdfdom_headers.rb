class UrdfdomHeaders < Formula
  desc "Headers for Unified Robot Description Format (URDF) parsers"
  homepage "https://wiki.ros.org/urdfdom_headers/"
  url "https://github.com/ros/urdfdom_headers/archive/1.0.2.tar.gz"
  sha256 "28d488d4a1542c427f09df23d443655db50405406f7b8e313eb0de499ce6b163"

  bottle do
    cellar :any_skip_relocation
    sha256 "bddc8c1985d764bee36ee25db4b3c18fe45b8de0f113875a3085489f3cd50d1d" => :mojave
    sha256 "9757800f4153efd48e5d77b3548da9a4b854165376eed6d541897f120a3d7da5" => :high_sierra
    sha256 "9757800f4153efd48e5d77b3548da9a4b854165376eed6d541897f120a3d7da5" => :sierra
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
