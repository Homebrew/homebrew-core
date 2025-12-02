class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "https://portal.nersc.gov/project/sparse/superlu/"
  url "https://github.com/xiaoyeli/superlu/archive/refs/tags/v7.0.0.tar.gz"
  sha256 "d7b91d4e0bb52644ca74c1a4dd466a694ddf1244a7bbf93cb453e8ca1f6527eb"
  license "BSD-3-Clause-LBNL"

  livecheck do
    url :homepage
    regex(/>SuperLU Version v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ebe6d27572f2d442006da1de3b99fa24adbe5685e2bb82b5d644ac4b60226e61"
    sha256 cellar: :any,                 arm64_sequoia:  "4254178b07c9d3a726c6275a30e940b31f26e4ca674ec2cc5731974831a3b254"
    sha256 cellar: :any,                 arm64_sonoma:   "a2b33d13c7cfc12be7928d7de630dc45c13afc610cdfb575fa1828a7c9ec2424"
    sha256 cellar: :any,                 arm64_ventura:  "0d9bdc7fc5edac4991f85b6bcf533011bb6f399287fbe243a0ea80721cddbd84"
    sha256 cellar: :any,                 arm64_monterey: "abf41ebe1584b1e8267de4464b1c3d9865a423709f4873e1cdd1cab5520d8f0a"
    sha256 cellar: :any,                 sonoma:         "2a8abc054e2595a4a3dd57840449adabf159c812eaf7d9d1a24c31dc0e125396"
    sha256 cellar: :any,                 ventura:        "595c90722cfb68db872db17c84ae8f85dcc6f296f4ce8a64cf5254c8c0b297d9"
    sha256 cellar: :any,                 monterey:       "40d93c338aec89af15f42e2d8a807e013daa8608f4fd6bc3f62f9581b86536f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3e3a619194aea2779fb2aa83e0baec2180d0da49742042361a50492069394323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e2bfcb8dec3fae7f0fcd94ee5515dd0d1a27327ae79a657c09b44f00299cf95"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "openblas"

  def install
    args = %W[
      -Denable_internal_blaslib=NO
      -DTPL_BLAS_LIBRARIES=#{Formula["openblas"].opt_lib}/#{shared_library("libopenblas")}
      -DBUILD_SHARED_LIBS=YES
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Source and data for test
    pkgshare.install "EXAMPLE/dlinsol.c"
    pkgshare.install "EXAMPLE/g20.rua"
  end

  test do
    pkgconf_cflags = shell_output("pkgconf --cflags --libs superlu").chomp.split
    system ENV.cc, pkgshare/"dlinsol.c", *pkgconf_cflags, "-o", "test"
    assert_match "No of nonzeros in L+U = 11886",
                 shell_output("./test < #{pkgshare}/g20.rua")
  end
end
