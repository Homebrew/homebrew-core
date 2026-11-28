class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https://visp.inria.fr/"
  url "https://visp-doc.inria.fr/download/releases/visp-3.7.0.tar.gz"
  sha256 "997f247f3702c83f0a8a6dc2f72ff98cfe3a5dcbd82f7c9f01d37ccd3b8ea97a"
  license "GPL-2.0-or-later"
  revision 12

  livecheck do
    url "https://visp.inria.fr/download/"
    regex(/href=.*?visp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "9f4587798b0eb74b6e0c5f8afded50d6573adab03c5253133388609c418f3755"
    sha256 cellar: :any, arm64_golden_gate: "2dfb5d4acb5a18002ce37035a1576ca45375edc4b72d45d3345cde0d1b91ed5d"
    sha256 cellar: :any, arm64_tahoe:       "27b6593dad57393f1aca07fbde2b317e06b03c2fecaff784753c3c2ebf3e6731"
    sha256 cellar: :any, arm64_sequoia:     "bbde8ffa7c1f0698f170601255e599eb228d53761e48fb1c1944f589cdd68e61"
    sha256 cellar: :any, arm64_linux:       "9ea3429de393b1db40148c089e973e1abe4563d8da37a7eee357ca18e72663ca"
    sha256 cellar: :any, x86_64_linux:      "e16d61712a9c375d900c2a99e967ce4c7d3a10c787c2a1a338106e134082431f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => [:build, :test]

  depends_on "eigen" => :no_linkage
  depends_on "jpeg-turbo"
  depends_on "libdc1394"
  depends_on "libpng"
  depends_on "openblas"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "vtk"
  depends_on "zbar"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "libomp"
  end

  # Link OpenCV 5's relocated geometry/features modules.
  patch do
    url "https://github.com/lagadic/visp/commit/d57def89b50849ca191355a5d2f624e61f5d4e00.patch?full_index=1"
    sha256 "93b53b9d44f239bc92f448b212ff14d9301773ca6acfa78dee038c1398f8a207"
    type :backport
    resolves "https://github.com/lagadic/visp/pull/1975"
  end

  # Include OpenCV 5's relocated method headers.
  patch do
    url "https://github.com/lagadic/visp/commit/0c170eaeefcf5a49c631f8298997cddfd6f28fd7.patch?full_index=1"
    sha256 "ca0893a0af556127fd18d630847b606a348ee53d21d6173b2fe4621952eef6de"
    type :backport
    resolves "https://github.com/lagadic/visp/pull/1962"
  end

  deny_network_access!

  def install
    # OpenCV 5.0.0 renamed the `3d` module to `geometry`.
    # PR ref: https://github.com/lagadic/visp/pull/1962
    inreplace %w[
      modules/core/include/visp3/core/vpMeterPixelConversion.h
      modules/core/include/visp3/core/vpPixelMeterConversion.h
      modules/core/src/camera/vpMeterPixelConversion.cpp
      modules/core/src/camera/vpPixelMeterConversion.cpp
      modules/vision/include/visp3/vision/vpKeyPoint.h
      modules/vision/src/key-point/vpKeyPoint.cpp
    ], "HAVE_OPENCV_3D", "HAVE_OPENCV_GEOMETRY"
    inreplace %w[
      modules/core/src/camera/vpMeterPixelConversion.cpp
      modules/core/src/camera/vpPixelMeterConversion.cpp
      modules/vision/src/key-point/vpKeyPoint.cpp
    ], "<opencv2/3d.hpp>", "<opencv2/geometry.hpp>"

    # OpenCV 5.1.0 removed `Mat_` comma initializers, so build these matrices from `Matx` instead
    # PR ref: https://github.com/lagadic/visp/pull/1962
    inreplace "modules/vision/src/key-point/vpKeyPoint.cpp",
              /\(cv::Mat_<(\w+)>\((\d+), (\d+)\) << ([^;]+)\);/, "cv::Mat(cv::Matx<\\1, \\2, \\3>(\\4));"

    # Avoid superenv shim references
    inreplace "CMakeLists.txt" do |s|
      s.sub!(/CMake build tool:"\s+\${CMAKE_BUILD_TOOL}/,
             "CMake build tool:            gmake\"")
      s.sub!(/C\+\+ Compiler:"\s+\${VISP_COMPILER_STR}/,
             "C++ Compiler:                #{ENV.cxx}\"")
      s.sub!(/C Compiler:"\s+\${CMAKE_C_COMPILER}/,
             "C Compiler:                  #{ENV.cc}\"")
    end

    # C++17 is minimum needed by PCL
    args = %w[
      -DBUILD_APPS=OFF
      -DBUILD_DEMOS=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_TUTORIALS=OFF
      -DUSE_CXX_STANDARD=17
      -DUSE_DC1394=ON
      -DUSE_EIGEN3=ON
      -DUSE_JPEG=ON
      -DUSE_LAPACK=ON
      -DUSE_LIBUSB_1=OFF
      -DUSE_MAVSDK=OFF
      -DUSE_OPENCV=ON
      -DUSE_PCL=ON
      -DUSE_PNG=ON
      -DUSE_PTHREAD=ON
      -DUSE_PYLON=OFF
      -DUSE_REALSENSE2=OFF
      -DUSE_X11=OFF
      -DUSE_XML2=ON
      -DUSE_ZBAR=ON
      -DUSE_ZLIB=ON
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac? # reduce overlinking

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Make sure software built against visp don't reference opencv's cellar path either
    opencv_prefix = formula_opt_prefix("opencv")
    inreplace [lib/"pkgconfig/visp.pc", lib/"cmake/visp/VISPConfig.cmake"],
              opencv_prefix.realpath, opencv_prefix

    # Replace versioned libraries, e.g. libopencv_core.5.1.0.dylib
    versioned_lib_regex = if OS.mac?
      %r{(/lib\w+)(?:\.\d+)+(\.dylib)([;"])}
    else
      %r{(/lib\w+)(\.so)(?:\.\d+)+([;"])}
    end
    inreplace lib/"cmake/visp/VISPModules.cmake", versioned_lib_regex, "\\1\\2\\3"

    return unless OS.mac?

    # Replace versioned libraries, e.g. -lopencv_core.5.1.0
    inreplace lib/"pkgconfig/visp.pc", /(-l\w+)(?:\.\d+)+( |$)/, "\\1\\2"

    # Replace versioned SDK paths
    audit_result = build.bottle?
    escaped_sdk_path = Regexp.escape(MacOS.sdk_for_formula(self).path)
    gl_path_pattern = '/System/Library/Frameworks/OpenGL\.framework/Versions/Current/Libraries/libGLU?\.tbd'
    inreplace(lib/"pkgconfig/visp.pc", %r{ -F#{escaped_sdk_path}(/\w*)* }, " ", audit_result:)
    inreplace lib/"cmake/visp/VISPModules.cmake" do |s|
      s.gsub!(%r{(?<=[;"])#{escaped_sdk_path}/usr/lib/libz.tbd([;"])}, "z\\1", audit_result:)
      s.gsub!(/(?<=[;"])#{escaped_sdk_path}#{gl_path_pattern}([;"])/, "-framework OpenGL\\1", audit_result:)
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <visp3/core/vpConfig.h>
      #include <iostream>
      int main()
      {
        std::cout << VISP_VERSION_MAJOR << "." << VISP_VERSION_MINOR <<
                "." << VISP_VERSION_PATCH << std::endl;
        return 0;
      }
    CPP
    pkg_config_flags = shell_output("pkgconf --cflags --libs visp").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", *pkg_config_flags
    assert_equal version.to_s, shell_output("./test").chomp

    ENV.delete "CPATH"
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
      project(visp-check)
      find_package(VISP REQUIRED)
      include_directories(${VISP_INCLUDE_DIRS})
      add_executable(visp-check test.cpp)
      target_link_libraries(visp-check ${VISP_LIBRARIES})
    CMAKE

    system "cmake", "-B", "build", "-S", "."
    system "cmake", "--build", "build"
    assert_equal version.to_s, shell_output("build/visp-check").chomp
  end
end
