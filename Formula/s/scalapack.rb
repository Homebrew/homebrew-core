class Scalapack < Formula
  desc "High-performance linear algebra for distributed memory machines"
  homepage "https://netlib.org/scalapack/"
  license "BSD-3-Clause"
  head "https://github.com/Reference-ScaLAPACK/scalapack.git", branch: "master"

  stable do
    url "https://github.com/Reference-ScaLAPACK/scalapack/archive/refs/tags/v2.2.2.tar.gz"
    sha256 "a2f0c9180a210bf7ffe126c9cb81099cf337da1a7120ddb4cbe4894eb7b7d022"

    # Backport commit for correct version number
    patch do
      url "https://github.com/Reference-ScaLAPACK/scalapack/commit/a23c2cdc6586c427686f6097ae66bb54ef693571.patch?full_index=1"
      sha256 "1a2c187595234c4c15007c4b1b847337a94c0a55bd807165743404942e6c5634"
    end

    # Backport support for CMake 4
    patch do
      url "https://github.com/Reference-ScaLAPACK/scalapack/commit/41ac62c28fab33cd9ccc1b010c9c215b5f05201b.patch?full_index=1"
      sha256 "930429e8fb118e58955a56f5f6bb82e797927cb31a83a8bb0190b7324f2d26f5"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95c2d6bfcad2cde73d0fab3e497efca73490469397f2c4e7961e7e2a34c76168"
    sha256 cellar: :any,                 arm64_sequoia: "dc18849ba919f1b668d9367aa6b3c33de0c5da835880a6cff52a0cec5e959480"
    sha256 cellar: :any,                 arm64_sonoma:  "04781e79d6a399a6b78be71b07b4f1ff77c52763637607b3784d9eed0a9d5871"
    sha256 cellar: :any,                 arm64_ventura: "cab596587baa484ed8304b5075f192dbbb867ea1794583937812d2e8b08f43e9"
    sha256 cellar: :any,                 sonoma:        "08ed075c53763c8c8bab09b40dcf7e20eb4931e4191d67d295587f7caacacbb5"
    sha256 cellar: :any,                 ventura:       "fed1f3d1a4eeca5c906e7c1bd84859631518e3901943fc5abce91823b8efdf91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72cefa05bf73039be8175869dd4d87edfd0fdd5b1c88d83e11b8e03fb77affdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ce59c95648217335fa463f14c0e3d2f87581f66ad82bdc5c0c60bda88b00048"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBLAS_LIBRARIES=#{blas}",
                    "-DLAPACK_LIBRARIES=#{blas}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "EXAMPLE"
  end

  test do
    cp_r (pkgshare/"EXAMPLE").children, testpath

    %w[psscaex pdscaex pcscaex pzscaex].each do |name|
      system "mpif90", "#{name}.f", "pdscaexinfo.f", "-L#{opt_lib}", "-lscalapack", "-o", name
      assert_match(/INFO code returned by .* 0/, shell_output("mpirun --map-by :OVERSUBSCRIBE -np 4 ./#{name}"))
    end
  end
end
