class UrdfdomHeaders < Formula
  desc "Headers for Unified Robot Description Format (URDF) parsers"
  homepage "https://wiki.ros.org/urdfdom_headers/"
  url "https://github.com/ros/urdfdom_headers/archive/refs/tags/2.0.1.tar.gz"
  sha256 "3b624b05119cb9d9c89495b6580663ba8fd138b7fb28769c1f756c1d11102f52"
  license "BSD-3-Clause"

  # Upstream uses Git tags (e.g. `1.0.0`) to indicate a new version. They
  # created a few releases on GitHub in the past but now they simply use tags.
  # See: https://github.com/Homebrew/homebrew-core/pull/158963#issuecomment-1879185279
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "09e2e16d5838468adb353600a570603c23e3ef665ec3effc2ce261676c54f7b8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <urdf_model/pose.h>
      int main() {
        double quat[4];
        urdf::Rotation rot;
        rot.getQuaternion(quat[0], quat[1], quat[2], quat[3]);
        return 0;
      }
    CPP

    system ENV.cxx, shell_output("pkg-config --cflags urdfdom_headers").chomp, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
