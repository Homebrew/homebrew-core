class Spglib < Formula
  desc "C library for finding and handling crystal symmetries"
  homepage "https://spglib.readthedocs.io/"
  url "https://github.com/spglib/spglib/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "6eb977053b35cd80eb2b5c3fa506a538ff2dad7092a43a612f4f0d4dc2069253"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "076dbf48095ccbcd03b975f7e000245ad896e002154d6726f65a153c50250715"
    sha256 cellar: :any,                 arm64_ventura:  "ea234e064949293d5f7e59f166903e0a584c6a38b17003cdf14b827ea720eda1"
    sha256 cellar: :any,                 arm64_monterey: "b415ef151c30804a7c45548a434dae8e613e7f19532fa3a2fe9e9931b52f7184"
    sha256 cellar: :any,                 sonoma:         "78231c5221d713ab26a2d64070ceda8d5e79af91ea2c05e0dff6fa7d040496d8"
    sha256 cellar: :any,                 ventura:        "0ec0215f5643d50e674729a2a9ba15a6eab51acf7d9759763dd411036f156b16"
    sha256 cellar: :any,                 monterey:       "8e69dd2763de14b943a879862b469b382907bdd62f1343ef0fb37211de9872f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c99aab6f75d48da47709e56ed5c19fcbb3650f3e1b86738325f1f39add4aef12"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    # TODO: Fortran packaging is disabled for now because packaging does not pick it up properly
    # https://github.com/spglib/spglib/issues/352#issuecomment-1784943807
    common_args = %w[
      -DSPGLIB_WITH_Fortran=OFF
    ]
    system "cmake", "-S", ".", "-B", "build_shared",
                   *common_args, "-DSPGLIB_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static",
                  *common_args, "-DSPGLIB_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"
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

    (testpath / "CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.6)
      project(test_spglib LANGUAGES C)
      find_package(Spglib CONFIG REQUIRED COMPONENTS shared)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Spglib::symspg)
    EOS
    system "cmake", "-B", "build_shared"
    system "cmake", "--build", "build_shared"
    system "./build_shared/test_c"

    (testpath / "CMakeLists.txt").delete
    (testpath / "CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.6)
      project(test_spglib LANGUAGES C Fortran)
      find_package(Spglib CONFIG REQUIRED COMPONENTS static)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Spglib::symspg)
    EOS
    system "cmake", "-B", "build_static"
    system "cmake", "--build", "build_static"
    system "./build_static/test_c"
  end
end
