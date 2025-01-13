class Scalapack < Formula
  desc "High-performance linear algebra for distributed memory machines"
  homepage "https://netlib.org/scalapack/"
  url "https://github.com/Reference-ScaLAPACK/scalapack/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "a2f0c9180a210bf7ffe126c9cb81099cf337da1a7120ddb4cbe4894eb7b7d022"
  license "BSD-3-Clause"
  head "https://github.com/Reference-ScaLAPACK/scalapack.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?scalapack[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "c995d114d9ed5d64a4478188051b057f1afbda10f860a6ad05240089014525f1"
    sha256 cellar: :any,                 arm64_sonoma:   "384fa978e53d02b1a25071e9cc0d89cd47a7d8881b735a946e947dca95590f25"
    sha256 cellar: :any,                 arm64_ventura:  "82500bf38af074441e92db1599b2594959d811b0bcee284c8cc36f92120525b4"
    sha256 cellar: :any,                 arm64_monterey: "4096375cb8f2af6801d1d0bbab6465b4e057e6c685ecf5e57f9f4fac8ea3166d"
    sha256 cellar: :any,                 sonoma:         "30b66a1c884bc106b96b9e82cde6d8b1c026f24307e8d5aeddb8bf4e3f91eff1"
    sha256 cellar: :any,                 ventura:        "5e64fada8dd814c16f4a2c620e8f1dc0b784519fc697ab1df907cc906aab6c8e"
    sha256 cellar: :any,                 monterey:       "168b5c717d4f360d03990e104b18d32f16e1da9cf1b2e5b6ee88fff8a0a5b33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f792514fdcdf56ca86e9b562b3a3f5e2fef3b2e84ea2648a68d0cda1cd60653"
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
      assert_match(/INFO code returned by .* 0/, shell_output("mpirun ./#{name}"))
    end
  end
end
