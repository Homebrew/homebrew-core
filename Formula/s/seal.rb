class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "af9bf0f0daccda2a8b7f344f13a5692e0ee6a45fea88478b2b90c35648bf2672"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "71cd829e65b350f05f5bc83a14b1c1050afab6c7976baa9bf14623a8e0386d60"
    sha256 cellar: :any,                 arm64_ventura:  "be6bc6562cd94e6cdaaaf9fea4678a9d203891103136b54ebebd207f925e1518"
    sha256 cellar: :any,                 arm64_monterey: "815a7f97fc5c9ac4f1dff9aefcfa9d8dc2de686db9986895cfdd03e67c532365"
    sha256 cellar: :any,                 arm64_big_sur:  "47554e0e49d403571cb2a8dd1556173684c9137bb1795041ab7ffbcf01f8c2ea"
    sha256 cellar: :any,                 sonoma:         "c547ee832fc5e1c7970aaf5d38b50ad4c527ff246965bb4b046faac577a6b3ff"
    sha256 cellar: :any,                 ventura:        "4913771595a3039b887b499c9a5432c6ec83a4e6bb53e426ab10451258cdfa5c"
    sha256 cellar: :any,                 monterey:       "1b4df4b2882c98e5577e0cbfe992ada1125250070e9343459c0451524d2f2831"
    sha256 cellar: :any,                 big_sur:        "01a9f4a313feac9bf415099ac09c9e3647bbf3304006ce06f871cf589c7e0588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "311dbf6d2608ee2921e86a72bb4bbe83c1e859676b4a95dabb3822ab700ff011"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "cpp-gsl"
  depends_on "zstd"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  resource "hexl" do
    url "https://github.com/intel/hexl/archive/refs/tags/v1.2.5.tar.gz"
    sha256 "3692e6e6183dbc49253e51e86c3e52e7affcac925f57db0949dbb4d34b558a9a"
  end

  # patch cmake configs, remove in next release
  patch do
    url "https://github.com/microsoft/SEAL/commit/13e94ef0e01aa9874885bbfdbca1258ab380ddeb.patch?full_index=1"
    sha256 "19e3dde5aeb78c01dbe5ee73624cf4621060d071ab1a437515eedc00b47310a1"
  end

  def install
    if Hardware::CPU.intel?
      resource("hexl").stage do
        hexl_args = std_cmake_args + %w[
          -DHEXL_BENCHMARK=OFF
          -DHEXL_TESTING=OFF
          -DHEXL_EXPORT=ON
        ]
        system "cmake", "-S", ".", "-B", "build", *hexl_args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
      ENV.append "LDFLAGS", "-L#{lib}"
    end

    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DSEAL_BUILD_DEPS=OFF
      -DSEAL_USE_ALIGNED_ALLOC=#{(OS.mac? && MacOS.version > :mojave) ? "ON" : "OFF"}
      -DSEAL_USE_INTEL_HEXL=#{Hardware::CPU.intel? ? "ON" : "OFF"}
      -DHEXL_DIR=#{lib}/cmake
      -DCMAKE_CXX_FLAGS=-I#{include}
    ]

    system "cmake", ".", *args
    system "make"
    system "make", "install"
    pkgshare.install "native/examples"
  end

  test do
    cp_r (pkgshare/"examples"), testpath

    # remove the partial CMakeLists
    File.delete testpath/"examples/CMakeLists.txt"

    # Chip in a new "CMakeLists.txt" for example code tests
    (testpath/"examples/CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.12)
      project(SEALExamples VERSION #{version} LANGUAGES CXX)
      # Executable will be in ../bin
      set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${SEALExamples_SOURCE_DIR}/../bin)

      add_executable(sealexamples examples.cpp)
      target_sources(sealexamples
          PRIVATE
              1_bfv_basics.cpp
              2_encoders.cpp
              3_levels.cpp
              4_bgv_basics.cpp
              5_ckks_basics.cpp
              6_rotation.cpp
              7_serialization.cpp
              8_performance.cpp
      )

      # Import Microsoft SEAL
      find_package(SEAL #{version} EXACT REQUIRED
          # Providing a path so this can be built without installing Microsoft SEAL
          PATHS ${SEALExamples_SOURCE_DIR}/../src/cmake
      )

      # Link Microsoft SEAL
      target_link_libraries(sealexamples SEAL::seal_shared)
    EOS

    system "cmake", "examples", "-DHEXL_DIR=#{lib}/cmake"
    system "make"
    # test examples 1-5 and exit
    input = "1\n2\n3\n4\n5\n0\n"
    assert_match "Correct", pipe_output("bin/sealexamples", input)
  end
end
