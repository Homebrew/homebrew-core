class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/v3.6.1.tar.gz"
  sha256 "e399c0df7fb60ad450a0ccfdc81b99d19308d0fc1f730d4cad4748dfb2fdb516"
  license "MIT"

  bottle do
    cellar :any
    sha256 "fa0987fdcf86b96cf972ff894bbdd8d24afc3e72c41cb9be25278b851ddb7986" => :big_sur
    sha256 "24878952d071677bb9822e46cef024ddbc7d382ecbef9531eecf663dc9335323" => :arm64_big_sur
    sha256 "59fb7528d124443c8443c1f9ccb8f12ab357e005f1755b9eb8a230a3426fb9dc" => :catalina
    sha256 "73257c6d562b234a97e320bbb1555fff03ce3bd3b2a8ce0530ba4ebbce883fe3" => :mojave
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
