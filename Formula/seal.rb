class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/v3.5.1.tar.gz"
  sha256 "9dfb1482d0bade6c1c76f2aa06aca6203f98aadc4ad94ca0f316be916b45fbd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5c7b9610572b1abce840e9cf88e5232771ea76559fb49776c87f3176f3c8815" => :catalina
    sha256 "9ab6a02da1750fb8deeefdadcab791017aea85b5921747af01c607c4e44e7eca" => :mojave
    sha256 "ac9e81e17df37c76f9f0db9218235b614a71d52442c961049f727062ace7c5fa" => :high_sierra
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
      project(SEALExamples VERSION 3.5.1 LANGUAGES CXX)
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
      find_package(SEAL 3.5.1 EXACT REQUIRED
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
