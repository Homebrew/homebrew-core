class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/v4.0.0.tar.gz"
  sha256 "616653498ba8f3e0cd23abef1d451c6e161a63bd88922f43de4b3595348b5c7e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ea53dd611311c919f58c7808143addd1998d7f2a3d28f58eed756ecb19ee98d4"
    sha256 cellar: :any,                 arm64_big_sur:  "a0bf775b0bc6b873a92eb9dc52856c7119d4ea78b99acf4a08a1973dc5ebbd8f"
    sha256 cellar: :any,                 monterey:       "992afd0a163c2aada6f229a5c8afb556d5a427f25b4561c793f3955a8460956f"
    sha256 cellar: :any,                 big_sur:        "322c2cf9c05b472e0fb6622f0476d5f53ff17a3cfd09ae5c4b9988386cba2bfb"
    sha256 cellar: :any,                 catalina:       "f3a21a40b17452fedb54680b5214faaafd1ef26f2e7c06d859a53985e83c771b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "409aab1c8e31f433ba23c9f08d4ae28ec858467043eedff6201b143beb9e8b63"
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
    url "https://github.com/intel/hexl/archive/v1.2.3.tar.gz"
    sha256 "f2cf33ee2035d12996d10b69d2f41a586b9954a29b99c70a852495cf5758878c"
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
