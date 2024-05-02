class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "https://portal.nersc.gov/project/sparse/superlu/"
  url "https://github.com/xiaoyeli/superlu/archive/refs/tags/v6.0.1.tar.gz"
  sha256 "6c5a3a9a224cb2658e9da15a6034eed44e45f6963f5a771a6b4562f7afb8f549"
  license "BSD-3-Clause-LBNL"

  livecheck do
    url :homepage
    regex(/>SuperLU Version v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a09972748fa9f0c51019515ee6f79c59dec305b445fdcb1df5eb3b03411a57ce"
    sha256 cellar: :any,                 arm64_ventura:  "1b77c62e3df8fa74e225128bc3549a0fbcd100d20d3fdc8e69b8d5079ece5645"
    sha256 cellar: :any,                 arm64_monterey: "416c4867f351007663616d1217a2f086fa8ea424b0cf8e2476706c6b89052321"
    sha256 cellar: :any,                 arm64_big_sur:  "5c2aa2bf3500e11bcb847b2cdaeadedc4352a322d974224cfa9a11aa57c4cd6b"
    sha256 cellar: :any,                 sonoma:         "45e6c7be8738def22a994d0331bf4c881e7a53ed39775dbc6857d973b600e0f1"
    sha256 cellar: :any,                 ventura:        "b1ad99f7201436cd3311b48c5711b0fddb2ae4a1fcd7148c08d611a1fb12775f"
    sha256 cellar: :any,                 monterey:       "d892bba3869f7729417657f2bff97e703a195c4194cfd9d6779c6e95708e9bed"
    sha256 cellar: :any,                 big_sur:        "79a64f6e540d32863c701c044594d060eb4951daa25e71cb219d298525b403de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4898aa53c8f5254013d20f299f162f60fbdfa10701917e9dd8f967c3f798047e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
  depends_on "gcc"
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
    pkg_config_cflags = shell_output("pkg-config --cflags --libs superlu").chomp.split
    system ENV.cc, pkgshare/"dlinsol.c", *pkg_config_cflags, "-o", "test"
    assert_match "No of nonzeros in L+U = 11886",
                 shell_output("./test < #{pkgshare}/g20.rua")
  end
end
