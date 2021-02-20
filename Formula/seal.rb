class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/v3.6.2.tar.gz"
  sha256 "86ffb0fee9ff155f7b33f496e10dacd00feeb45f21803907dcc0f48f2addc51b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "cf25c3c0080238996da377be83d693edc4c2b83882516ad6ee65d974a7b71986"
    sha256 cellar: :any, big_sur:       "854c25413b41bf8c2ac8ac04b5ec91a9e10ab275cc7d5f2e0a489ce66ec2c620"
    sha256 cellar: :any, catalina:      "3e25c674afd729b55034792370bd8e241a15d8f29f0acd9896fee54072dcca7b"
    sha256 cellar: :any, mojave:        "767a0db73af062e3aae931f987335e8eaa1914ea31781439dbfba553cd4bef64"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-DBUILD_SHARED_LIBS=ON", ".", *std_cmake_args
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

    system "cmake", "examples"
    system "make"
    # test examples 1-5 and exit
    input = "1\n2\n3\n4\n5\n0\n"
    assert_match "Correct", pipe_output("bin/sealexamples", input)
  end
end
