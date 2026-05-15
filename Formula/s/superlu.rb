class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "https://portal.nersc.gov/project/sparse/superlu/"
  url "https://github.com/xiaoyeli/superlu/archive/refs/tags/v7.0.1.tar.gz"
  sha256 "86dcca1e086f8b8079990d07f00eb707fc9ef412cf3b2ce808b37956f0de2cb8"
  license "BSD-3-Clause-LBNL"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "effe04f1a11b47d86cbe720ee1bcfae0e73b8b8967a84e02b0faa6628d8b1ea0"
    sha256 cellar: :any,                 arm64_sequoia: "2e52b920e55c0afc6d931e38c65178f5d09404b657b6d83740e14cc846c4540a"
    sha256 cellar: :any,                 arm64_sonoma:  "19b4a72e92d4f21463719e77c704eac878b90f4289a3e73629e3de4778e0c183"
    sha256 cellar: :any,                 sonoma:        "fd42d302b82283fa235c95b33ea817827597de779bbac6662ba05132626e3230"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a23f58a2c959e8cb6a430e11d5055c947344e5881e18b4e88baa73121d81139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7416ff44fcf9b76c0646b8273e1c689621aff0016d1673e9fe25329111305c1"
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
