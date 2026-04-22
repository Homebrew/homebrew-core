class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "acc2a1a127a85d1e1ffcca3ffd148f736e665df6d6b072df0e42fff64795a13c"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "c2b43ab3584c6568ba43786b9ab734c78c86a569efff42025a07b34584d880bc"
    sha256 cellar: :any,                 arm64_sequoia: "39ed846791c3055f424593bdeaf451b6d1623f69128827591c5cf91932d3b26b"
    sha256 cellar: :any,                 arm64_sonoma:  "2d44b452c5332cfdf95cbd883e1247fc86b644712c85a38cf8c1a2bb68607090"
    sha256 cellar: :any,                 sonoma:        "755f905a1b01a50e5e6e7743f4cee17ebec09936f15cc069b804b72baaf031b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7d87708dcfef3a3c12c3d2341defb5bee81ee1a4d5eb9a51a76990bb9ac784c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "039ccc740daf1ddc76cef431eac86b73bcf385a78699eb7e247ef1bea16e4178"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "cpp-gsl"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "hexl" do
    url "https://github.com/IntelLabs/hexl/archive/refs/tags/v1.2.5.tar.gz"
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
        hexl_args = %w[
          -DHEXL_BENCHMARK=OFF
          -DHEXL_TESTING=OFF
          -DHEXL_EXPORT=ON
          -DCMAKE_POLICY_VERSION_MINIMUM=3.5
        ]
        system "cmake", "-S", ".", "-B", "build", *hexl_args, *std_cmake_args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
      ENV.append "LDFLAGS", "-L#{lib}"
    end

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DSEAL_BUILD_DEPS=OFF
      -DSEAL_USE_ALIGNED_ALLOC=#{OS.mac? ? "ON" : "OFF"}
      -DSEAL_USE_INTEL_HEXL=#{Hardware::CPU.intel? ? "ON" : "OFF"}
      -DHEXL_DIR=#{lib}/cmake
      -DCMAKE_CXX_FLAGS=-I#{include}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "native/examples"
  end

  test do
    cp_r (pkgshare/"examples"), testpath

    # remove the partial CMakeLists
    File.delete testpath/"examples/CMakeLists.txt"

    # Chip in a new "CMakeLists.txt" for example code tests
    (testpath/"examples/CMakeLists.txt").write <<~CMAKE
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
    CMAKE

    system "cmake", "-S", "examples", "-B", "build", "-DHEXL_DIR=#{lib}/cmake"
    system "cmake", "--build", "build", "--target", "sealexamples"

    # test examples 1-5 and exit
    input = "1\n2\n3\n4\n5\n0\n"
    assert_match "Parameter validation (success): valid", pipe_output("bin/sealexamples", input)
  end
end
