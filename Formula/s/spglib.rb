class Spglib < Formula
  desc "C library for finding and handling crystal symmetries"
  homepage "https://spglib.readthedocs.io/en/latest/"
  url "https://github.com/spglib/spglib/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "b22fc9abae9716c574fbc6d55cfc53ed654a714fccc5657a26ff5d18114bd8bd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ac52612168b066678114e398e0c280774a507fa7368dac07b1485b93c268846"
    sha256 cellar: :any,                 arm64_sequoia: "98e08556202a78099fb3ef2677d981b9d45205f79ee5ec513c40585710fbfa08"
    sha256 cellar: :any,                 arm64_sonoma:  "edecb2cca0fec6d88c7254a587a5a5d894d9780085614704cdb31d83cbb54e45"
    sha256 cellar: :any,                 sonoma:        "b04a116c09270ca9d4a648abb13330250b7131eeb5927453780af847dd50903b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3af78dc77ef69efe7487239209ea4f4fb73d149dc03e8e140c89d71f91987b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79a41e046b7f33096acbbc6018b0e23885cd732501dbc0083aa1c77ea5abfcce"
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
