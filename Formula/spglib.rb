class Spglib < Formula
  desc "C library for finding and handling crystal symmetries"
  homepage "https://spglib.readthedocs.io/"
  url "https://github.com/spglib/spglib/archive/refs/tags/v2.1.0-rc1.tar.gz"
  sha256 "ec4314b69ceaa6bad736bce71875c6260c1b2fd661735c920c96a0d49cdbd53f"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
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
end
