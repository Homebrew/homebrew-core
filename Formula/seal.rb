class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/v3.5.4.tar.gz"
  sha256 "0c325c3e3d9b77be63ef866a7c73de861be46b99b61a22be60518d34865a1f37"
  license "MIT"

  bottle do
    cellar :any
    sha256 "a6220dff48ac029ae26e262ac604267a9df4c36f444878af75864bee18f305c1" => :catalina
    sha256 "2e7ea5ac3e4c7f2771929d610cc2a4c4527d0687e9beb834484a408641dd6ef3" => :mojave
    sha256 "73e34c7c5517f9a57d9f6bfb94ce5902dca5af69bc05b20a8dd6fd5d3d2653dc" => :high_sierra
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
      target_link_libraries(sealexamples SEAL::seal)
    EOS

    system "cmake", "examples"
    system "make"
    # test examples 1-5 and exit
    input = "1\n2\n3\n4\n5\n0\n"
    assert_match "Correct", pipe_output("bin/sealexamples", input)
  end
end
