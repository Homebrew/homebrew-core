class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "https://github.com/vrpn/vrpn/wiki"
  # Avoid git checkout which pulls in bundled libraries as submodules
  url "https://github.com/vrpn/vrpn/archive/refs/tags/v07.36.tar.gz"
  sha256 "bed00ae060fc7c0cfdaa2fa01f6f2db4976d431971e8824b710eb63cfbba0df7"
  license "BSL-1.0"
  head "https://github.com/vrpn/vrpn.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7a981cfd4e68e7163f971f6e56085100c03ac7520145e90f7323f2b5c2751934"
    sha256 cellar: :any,                 arm64_sequoia: "d99728e78e407b8273e823ce437e72c974a74b04c96b51e07d32933dcfc8a75d"
    sha256 cellar: :any,                 arm64_sonoma:  "9a640c1246bb42659b8f827c27e0102f22b42455cd0da26ea634c60ecf9def79"
    sha256 cellar: :any,                 sonoma:        "5430e050e017cf4f2be4f9022f0c8619464064c9ce3894cdb5d61447417caae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae557530fbcb369b6ada4d947509c369cb73a4c04705733e15d881a09c0ca5ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc618017186b6bad9f673099037a120edae12fcef7cf7ed07820117888b4a4b0"
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
