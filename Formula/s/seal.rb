class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/refs/tags/v4.7.3.tar.gz"
  sha256 "6783e2734aef49db4441df5e60c51d4f624e79ec6b63a446fddcd5766f9829e2"
  license "MIT"

  bottle do
    manifest_sha256 "a8a16e4474361b1882324ec92af8e2eaca77ce4ce1642652f5742b71360712d7"
    sha256 cellar: :any, arm64_golden_gate: "4e0dcabd933a0bf6bf54762858f5f1d5fe27b8e067160028912db4391e0c7723"
    sha256 cellar: :any, arm64_tahoe:       "07e8d6e8dd98d7c0209bc0791affd9836bf62118972ebab9d0e874dc0c950795"
    sha256 cellar: :any, arm64_sequoia:     "908d3080a14f61074bc928d5eee12a9c0983349d241e96d986f2b0b556c66d95"
    sha256 cellar: :any, arm64_linux:       "ecfd87b69281e260fc7bfd35174826c12fe62542adafd699a4b5e88cbb8a58fb"
    sha256 cellar: :any, x86_64_linux:      "805f5557542d40ce271032cdcfe698111d5b8ad13d5f6c1c24c18a3183b9a8fb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "cpp-gsl"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  on_intel do
    depends_on "cpu_features"
  end

  resource "hexl" do
    url "https://github.com/IntelLabs/hexl/archive/refs/tags/v1.2.6.tar.gz"
    sha256 "5035cedff6984060c10e2ce7587dab83483787ea2010e1b60d18d19bb3538f3b"
  end

  deny_network_access!

  def install
    if Hardware::CPU.intel?
      resource("hexl").stage do
        hexl_args = %w[
          -DHEXL_BENCHMARK=OFF
          -DHEXL_TESTING=OFF
          -DCMAKE_POLICY_VERSION_MINIMUM=3.5
        ]
        system "cmake", "-S", ".", "-B", "build", *hexl_args, *std_cmake_args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
      ENV.append "LDFLAGS", "-L#{lib}"
    end

    build_headers = OS.mac? ? "ON" : "OFF"
    use_hexl = Hardware::CPU.intel? ? "ON" : "OFF"
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DSEAL_BUILD_DEPS=OFF
      -DSEAL_USE_ALIGNED_ALLOC=#{build_headers}
      -DSEAL_USE_INTEL_HEXL=#{use_hexl}
      -DCMAKE_CXX_FLAGS=-I#{include}
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
          PATHS #{lib}/cmake/SEAL
          NO_DEFAULT_PATH
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
