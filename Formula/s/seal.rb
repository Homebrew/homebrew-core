class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "2c843054d795d0f36944e5cf1e9ab4b72b239af2ab427905394ed1c69c13bca3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "310246ba73ca19467d57d849615901dfb226cbc853ef692a4318ec6b1bb3434a"
    sha256 cellar: :any,                 arm64_sequoia: "0790b479d8372b06b3c33790ca3d765d4c43d02a53868ce0c4d3aec022aa4563"
    sha256 cellar: :any,                 arm64_sonoma:  "c09da5e90916e6b613229eddd7eafcc0217d02fb864fac78a56fcca3f3f09ffa"
    sha256 cellar: :any,                 sonoma:        "2d89ebd79f9023f7a6fa8cc707a4692def14c81edfe9455bf5cae8f64f661f77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95d4a668b5018d0244734827d32e22197b5ea2d34761d0ecca6ffa221370d936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f6afd5fba812cc64ec7756a4caadb2f83def5c484c1b6aaa5e08b9483bdcc04"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "cpp-gsl"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "hexl" do
    url "https://github.com/IntelLabs/hexl/archive/refs/tags/v1.2.6.tar.gz"
    sha256 "5035cedff6984060c10e2ce7587dab83483787ea2010e1b60d18d19bb3538f3b"
  end

  # Fix to error for package "HEXL" that is compatible with requested version "1"
  # PR ref: https://github.com/microsoft/SEAL/pull/740
  patch do
    url "https://github.com/microsoft/SEAL/commit/7d449845499f64232c6870085e96e4fd7493e752.patch?full_index=1"
    sha256 "b48c681ac957b3c7fcc7aad2ac456e3301e2320e00c464d0fec3d95225681548"
  end

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

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DSEAL_BUILD_DEPS=OFF
      -DSEAL_USE_ALIGNED_ALLOC=#{OS.mac? ? "ON" : "OFF"}
      -DSEAL_USE_INTEL_HEXL=#{Hardware::CPU.intel? ? "ON" : "OFF"}
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
