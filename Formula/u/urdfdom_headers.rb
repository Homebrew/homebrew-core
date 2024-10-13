class UrdfdomHeaders < Formula
  desc "Headers for Unified Robot Description Format (URDF) parsers"
  homepage "https://wiki.ros.org/urdfdom_headers/"
  url "https://github.com/ros/urdfdom_headers/archive/refs/tags/1.1.2.tar.gz"
  sha256 "7602e37c6715fbf4cec3f0ded1e860157796423dc79da062a0e5ccb1226dc8e6"
  license "BSD-3-Clause"

  # Upstream uses Git tags (e.g. `1.0.0`) to indicate a new version. They
  # created a few releases on GitHub in the past but now they simply use tags.
  # See: https://github.com/Homebrew/homebrew-core/pull/158963#issuecomment-1879185279
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99db8197b364ac4ed1adf8d48e245c2f08d714f205e033b8b5bf0987ede639ce"
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
