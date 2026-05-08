class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "https://github.com/vrpn/vrpn/wiki"
  # Avoid git checkout which pulls in bundled libraries as submodules
  url "https://github.com/vrpn/vrpn/archive/refs/tags/v07.36.tar.gz"
  sha256 "bed00ae060fc7c0cfdaa2fa01f6f2db4976d431971e8824b710eb63cfbba0df7"
  license "BSL-1.0"
  revision 1
  head "https://github.com/vrpn/vrpn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9603f17d75a969d12480768a545cc130101048f060fcd729183634d424989822"
    sha256 cellar: :any,                 arm64_sequoia: "46b2a9dea5c5c51546765597b55f52c5ae57e5925dc02b1e78cdaf2ebed0ccb2"
    sha256 cellar: :any,                 arm64_sonoma:  "676d4ad9c12df857f5953140b7c547041f70954d23c815609b995b2b39709bde"
    sha256 cellar: :any,                 sonoma:        "25ef7f6f6ac199d06d3b6317f0ab7e0ffd0d5fd7c551ae9ce1fbfe7e8428d85d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eec1d88a5687a1cdd327f2102ebe966a79eec1bb3759739029441e7bdee56461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "217a232e86cccbb540c9b2630f73936c5af3357e77425fc307ea62eb948d26a4"
  end

  depends_on "cmake" => :build
  depends_on "hidapi"
  depends_on "jsoncpp"
  depends_on "libusb" # for HID support

  def install
    # Workaround for jsoncpp_lib resulting in jsoncpp_lib-NOTFOUND which may be
    # a side effect of switching the `jsoncpp` build to meson.
    inreplace "cmake/FindJsonCpp.cmake",
              "set(JSONCPP_LIBRARY ${JSONCPP_IMPORTED_LIBRARY})",
              "set(JSONCPP_LIBRARY \"#{Formula["jsoncpp"].opt_lib/shared_library("libjsoncpp")}\")"

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_CXX_STANDARD=11
      -DVRPN_BUILD_CLIENTS=OFF
      -DVRPN_BUILD_JAVA=OFF
      -DVRPN_BUILD_PYTHON=OFF
      -DVRPN_BUILD_PYTHON_HANDCODED_3X=OFF
      -DVRPN_USE_LOCAL_HIDAPI=OFF
      -DVRPN_USE_LOCAL_JSONCPP=OFF
      -DVRPN_USE_WIIUSE=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <vrpn_Analog.h>
      int main() {
        vrpn_Analog_Remote *analog = new vrpn_Analog_Remote("Tracker0@localhost");
        if (analog) {
          std::cout << "vrpn_Analog_Remote created successfully!" << std::endl;
          delete analog;
          return 0;
        }
        return 1;
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lvrpn"
    system "./test"

    system bin/"vrpn_server", "-h"
  end
end
