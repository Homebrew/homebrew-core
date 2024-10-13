class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "55601ea4c9ab96eb29a8e37027637774e64a2868d02852474d625ffced0b92cb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "95d3610de7c109265e775fcb6ef1547f2cb2f71d2be1a0e1d3c616cc0a708157"
    sha256 cellar: :any,                 arm64_sonoma:   "fde6d946891affcafc3e5231b576a1b67aed87ab83cd225eace77d72827b1193"
    sha256 cellar: :any,                 arm64_ventura:  "45449875a4c66daedc4730ee32d6c9d03875fc2139927d7c9e5716ebc2598e94"
    sha256 cellar: :any,                 arm64_monterey: "b782ba0559923f33086a020b63ab5bcd05fa5262f40a166eb0d3be7ebdd26131"
    sha256 cellar: :any,                 sonoma:         "f2d97c6b546621bc7a19cf8825787ec57f953ce9caa36d9e41005611d0262e00"
    sha256 cellar: :any,                 ventura:        "7dcd8c0c88ffe2156af805090507e07389f5a66213f72b48a5ba817929f8b2a2"
    sha256 cellar: :any,                 monterey:       "0d4a9d88654ccfc0becd6841ed2eaabdfb5673aae8b8477c8751de112404295b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "284c52f3e1190e14db52e5cf0518ef6fb78011b2a611d7081b1572ca0933ce19"
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

    system "cmake", "-S", "examples", "-B", "build", "-DHEXL_DIR=#{lib}/cmake"
    system "cmake", "--build", "build", "--target", "sealexamples"

    # test examples 1-5 and exit
    input = "1\n2\n3\n4\n5\n0\n"
    assert_match "Parameter validation (success): valid", pipe_output("bin/sealexamples", input)
  end
end
