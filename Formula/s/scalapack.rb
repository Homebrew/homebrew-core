class Scalapack < Formula
  desc "High-performance linear algebra for distributed memory machines"
  homepage "https://netlib.org/scalapack/"
  url "https://github.com/Reference-ScaLAPACK/scalapack/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "5d93701eca663925e98010dd8d0f45fd79b2191d74e5afa5711d587370a8b9dd"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Reference-ScaLAPACK/scalapack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea0aacd209ff09443ac7fd62e5782b6aa5708b6cf3d9d25e651a95532522e0a9"
    sha256 cellar: :any,                 arm64_sequoia: "0a7ab3a13e290659080c05f2550e282039f316eb9a11741905ac40842f301df4"
    sha256 cellar: :any,                 arm64_sonoma:  "39ff3f7f5f335b43fa3216ac699c7408f441a8b927075ff8e3edf53186149ec9"
    sha256 cellar: :any,                 sonoma:        "afe7500c3c7c76d21879fb8a76d5cb3d6b8aa66a46b30311fc1196b7d5304e35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e46a44670c4655f65121281ae8325b26e53730fc1fabdfdee24f7baa1408a276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b120c99f85e37c43d20ae4775cb1d9953e35ad07c8afec88d5966ab6f6d0dcdb"
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
