class Spglib < Formula
  desc "C library for finding and handling crystal symmetries"
  homepage "https://spglib.readthedocs.io/en/latest/"
  url "https://github.com/spglib/spglib/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "c65af71136c915352eb82444b165ec83289877eb8e46593033f199801b43dbf7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1f0145c7fce622faa3b2663a0e5f3dc807d71d5d325a0284959a89db1512ed1"
    sha256 cellar: :any,                 arm64_sequoia: "1f70bfc567f1349913975ebe3a2173dfb68dd234dab1a6fd199f62b494a75919"
    sha256 cellar: :any,                 arm64_sonoma:  "f4b1b449ad705a09d66de2d0b3868f7ed6d4cec38aea989e4639529e3bbf4f46"
    sha256 cellar: :any,                 arm64_ventura: "ab9d0638a60bc897b4d3ce4f2f37e451df8470f15af4eb7e638253673b636622"
    sha256 cellar: :any,                 sonoma:        "0c8d96842c11f26dcde4627aaec4d0a89739e65e7315f8b933162e88483ac2e6"
    sha256 cellar: :any,                 ventura:       "d1cef9ba99ecafd8b47b46a1f1e00f4203f371a08943cd986e2469a07534e737"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23b327e09f38b1b1a3b1e66a78502dd0f48019876b43f657bf5303f7d3db046f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0e14500cec9a4a450740bd534d71ac558d58faf86b3ae893aa4b3ba33c09d44"
  end

  depends_on "cmake" => [:build, :test]

  def install
    # TODO: Fortran packaging is disabled for now because packaging does not pick it up properly
    # https://github.com/spglib/spglib/issues/352#issuecomment-1784943807
    common_args = %w[
      -DSPGLIB_WITH_Fortran=OFF
      -DSPGLIB_WITH_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build_shared",
                    "-DSPGLIB_SHARED_LIBS=ON",
                    *common_args, *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static",
                    "-DSPGLIB_SHARED_LIBS=OFF",
                    *common_args, *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"
  end

  test do
    (testpath / "test.c").write <<~C
      #include <stdio.h>
      #include <spglib.h>
      int main()
      {
        printf("%d.%d.%d", spg_get_major_version(), spg_get_minor_version(), spg_get_micro_version());
      }
    C

    (testpath / "CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test_spglib LANGUAGES C)
      find_package(Spglib CONFIG REQUIRED COMPONENTS shared)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Spglib::symspg)
    CMAKE
    system "cmake", "-B", "build_shared"
    system "cmake", "--build", "build_shared"
    system "./build_shared/test_c"

    (testpath / "CMakeLists.txt").delete
    (testpath / "CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test_spglib LANGUAGES C)
      find_package(Spglib CONFIG REQUIRED COMPONENTS static)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Spglib::symspg)
    CMAKE
    system "cmake", "-B", "build_static"
    system "cmake", "--build", "build_static"
    system "./build_static/test_c"
  end
end
