class Spglib < Formula
  desc "C library for finding and handling crystal symmetries"
  homepage "https://spglib.readthedocs.io/"
  url "https://github.com/spglib/spglib/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "ac929e20ec9d4621411e2cdec59b1442e02506c1e546005bbe2c7f781e9bd49a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5911be8110caa19a48ba5ec884182506300cd08bc32b9ebb02a96403e1bcc3fa"
    sha256 cellar: :any,                 arm64_ventura:  "962499b9d28386bb78076b9d35261c7a97393305b0d9d415ba9f33324197fb53"
    sha256 cellar: :any,                 arm64_monterey: "bae90e995fe2a1442b1a9b8056dd24c71deb65fd25b9cf5e3cd95a9ec280a923"
    sha256 cellar: :any,                 sonoma:         "556970e798d2e06fbedd3b61b9f8158685d1bcb6e50dad793b1224e58e0e1a35"
    sha256 cellar: :any,                 ventura:        "15e8b05b0faf058629fdc1a310c3c7b9bfb2d9dcbd1dda26844f79e483e90956"
    sha256 cellar: :any,                 monterey:       "5016e46b335a7b91ae123e208bfc6449b0d5cd6433317f96d66976c5d61f640d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc3d19eb250359ec5ebf9440e8203d364a147f94f024d57ab80dd1cbc2d67276"
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
