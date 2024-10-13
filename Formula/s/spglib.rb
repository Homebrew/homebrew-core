class Spglib < Formula
  desc "C library for finding and handling crystal symmetries"
  homepage "https://spglib.readthedocs.io/"
  url "https://github.com/spglib/spglib/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "b6026f5e85106c0c9ee57e54b9399890d0f29982e20e96ede0428b3efbe6b914"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cc28d8bb51579426370ae21dfa69ffdb92d0c7a05023a1f6270c47b309165a62"
    sha256 cellar: :any,                 arm64_sonoma:   "8a2df8ea5096a46219d4cab39325fe79365a2dc68e9efc6a2dc2ea430b3f9efe"
    sha256 cellar: :any,                 arm64_ventura:  "8ace7d08ecd61605d682f2a5b87fb4a4010ee819a87c0177be207f6a5a305b1c"
    sha256 cellar: :any,                 arm64_monterey: "83311332c6f4685f7408c76ffedf5ae64644950cd011cfd371085f4f4022be85"
    sha256 cellar: :any,                 sonoma:         "88724f0154cb402795766cea37785eae847871e85a419d7f82eaa06ff1fc4235"
    sha256 cellar: :any,                 ventura:        "6051179af2cee2eaa4adfe74000b013ca7ab7b84e87e52cbc9906954f37b4175"
    sha256 cellar: :any,                 monterey:       "ed1bb26d268f7ac936404d37c60d9f2cb9819b030076fe282a72eef1b9af790d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c462ceb42ed8e965c52f74e3b35500be3f9646a46a7fccba729f6272261986f5"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    # TODO: Fortran packaging is disabled for now because packaging does not pick it up properly
    # https://github.com/spglib/spglib/issues/352#issuecomment-1784943807
    common_args = %w[
      -DSPGLIB_WITH_Fortran=OFF
      -DSPGLIB_WITH_TESTS=OFF
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
