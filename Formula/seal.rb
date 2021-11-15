class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/v3.7.1.tar.gz"
  sha256 "cdc7426d01f879a8b87204a5df9e01339262d4b53962f6fddc2f34a0dec71777"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "23beceb2de3f10406360d6dd91ed9aa386e7e94a368c9457918d3581106c2a7b"
    sha256 cellar: :any,                 big_sur:       "d6c02002668e4a85b55881dceab6d3e8f4b6ee7ee805c008cd0e8e0b5b991434"
    sha256 cellar: :any,                 catalina:      "e73d859446af694f6914ee025a73d707cbc873ec3bba65e6f25a88850313f3f4"
    sha256 cellar: :any,                 mojave:        "94cd84ae736c28a2c234333fb90b5c68933a26e60edbb569c8d2fb00326db170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc947e560250392fc1a7128849d62cc9d6921e0dea814485ce8c8a1ad0b1061a"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "cpp-gsl"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "hexl" do
    url "https://github.com/intel/hexl/archive/v1.2.1.tar.gz"
    sha256 "d09f4bf5309f4fa13f0046475f77e8c5a065d7b9c726eba2d3d943fc13cdae1a"
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
      -DSEAL_USE_ALIGNED_ALLOC=#{(MacOS.version > :mojave) ? "ON" : "OFF"}
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
              4_ckks_basics.cpp
              5_rotation.cpp
              6_serialization.cpp
              7_performance.cpp
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
