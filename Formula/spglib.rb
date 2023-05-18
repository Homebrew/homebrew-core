class Spglib < Formula
  desc "C library for finding and handling crystal symmetries"
  homepage "https://spglib.readthedocs.io/"
  url "https://github.com/spglib/spglib/archive/refs/tags/v2.1.0-rc1.tar.gz"
  sha256 "ec4314b69ceaa6bad736bce71875c6260c1b2fd661735c920c96a0d49cdbd53f"
  license "BSD-3-Clause"

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    system "cmake",
           "-B", "build",
           "-DSPGLIB_WITH_Fortran=ON",
           "-DSPGLIB_SHARED_LIBS=ON",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath / "test.c").write <<~EOS
      #include <stdio.h>
      #include <spglib.h>
      int main()
      {
        printf("%d.%d.%d", spg_get_major_version(), spg_get_minor_version(), spg_get_micro_version());
      }
    EOS

    (testpath / "test.f90").write <<~EOS
      program spglibtest
        use spglib_f08
      end program spglibtest
    EOS

    (testpath / "CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.6)
      project(test_spglib LANGUAGES C Fortran)
      find_package(Spglib CONFIG REQUIRED)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Spglib::symspg)
      add_executable(test_fortran test.f90)
      target_link_libraries(test_c PRIVATE Spglib::fortran)
    EOS
    system "cmake", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test_c"
    system "./build/test_fortran"
  end
end
