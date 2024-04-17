class Spglib < Formula
  desc "C library for finding and handling crystal symmetries"
  homepage "https://spglib.readthedocs.io/"
  url "https://github.com/spglib/spglib/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "e33694b189c6864f719a59c31e2af55301a524fb68ba9fb65f08e95af471847d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "de01ae5818606638b18d896634358d37f2ce5a87cdd12899ac3beaff6bec43a4"
    sha256 cellar: :any,                 arm64_ventura:  "9a41890d5e23dc309c55e4d1313d44bfdb94935091f626b185bc72ed1a67daa9"
    sha256 cellar: :any,                 arm64_monterey: "1a5df6a31488c0e5543fcbdee8852c874f1808e0cf60a5624dae00f029c401ac"
    sha256 cellar: :any,                 sonoma:         "4f2c67e008cf11a608a5eb50dd9c04bd1018920979c17d36adda89b43fe9fbd6"
    sha256 cellar: :any,                 ventura:        "44369ffdb739d50b1d9ce775bcbb6a479040e04cc172d09f06bc9632437d7956"
    sha256 cellar: :any,                 monterey:       "0b8f9379dfe647b641c754dd0770e17818d050d2a3caeaeaab11ec4bbd5af5d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6499c24ed7d5dbb6de0e62ed7b6e49ebc77235d464da36f0556d29232539464"
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
