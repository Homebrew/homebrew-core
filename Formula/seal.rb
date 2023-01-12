class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "af9bf0f0daccda2a8b7f344f13a5692e0ee6a45fea88478b2b90c35648bf2672"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "0dd23ba22353615762f25747bb49e2b7b01b68fe1bee34fa1aa2db56a64bbb02"
    sha256 cellar: :any,                 arm64_monterey: "d7777ee9fe71f92c9900365ca44547b539c371d64b6c60719e39577f8393eb89"
    sha256 cellar: :any,                 arm64_big_sur:  "edf57735aa66bfabe77f812f343eda0e8cef6ab82ab8f485e1c99ae85197dcb1"
    sha256 cellar: :any,                 ventura:        "ef8b46670dd9780f5490a276e52bfb4f04ebcf5da2cfbbc36f7c12e28eda9a84"
    sha256 cellar: :any,                 monterey:       "27af2b9d7c694e1cc8e78036698a64bd2ebac7c0b3ed51392b8b601cd27ea961"
    sha256 cellar: :any,                 big_sur:        "0894b4b4a67025a78aa99fb4a3e1403582c0150612b309a92cf0717fbb84475f"
    sha256 cellar: :any,                 catalina:       "bbe794b1b0316b97c4a1024cfbbde2012dbb52b4684696ba2795f221a99ccd4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72fb7e142c831ee8615d16e01cc981dc51d001b50b6726a0c3d6084a360983f4"
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
