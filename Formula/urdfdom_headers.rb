class UrdfdomHeaders < Formula
  desc "Headers for Unified Robot Description Format (URDF) parsers"
  homepage "https://wiki.ros.org/urdfdom_headers/"
  url "https://github.com/ros/urdfdom_headers/archive/1.0.2.tar.gz"
  sha256 "28d488d4a1542c427f09df23d443655db50405406f7b8e313eb0de499ce6b163"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbd3025633aa48a122b312f6693d9e8e493b51cc34e6024c06e048e5fbe2a0ff" => :mojave
    sha256 "3b937204b1bd92e9c290dfc9df366c2978352be8551a47910ac637d863a6f585" => :high_sierra
    sha256 "3b937204b1bd92e9c290dfc9df366c2978352be8551a47910ac637d863a6f585" => :sierra
    sha256 "3b937204b1bd92e9c290dfc9df366c2978352be8551a47910ac637d863a6f585" => :el_capitan
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
