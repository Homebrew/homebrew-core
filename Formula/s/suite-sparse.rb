class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.7.0.tar.gz"
  sha256 "529b067f5d80981f45ddf6766627b8fc5af619822f068f342aab776e683df4f3"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "Apache-2.0",
    "GPL-3.0-only",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d078330ca586c489c1ce288b0038cf24af982e72150b95cab37f9e42025ece24"
    sha256 cellar: :any,                 arm64_ventura:  "65c7b70914dcbe9470117fb35aa0bdc7f751146922d2ef36b91f05147d8153d4"
    sha256 cellar: :any,                 arm64_monterey: "394e3c0ff008362f89df35ff41618f7cab48b5376fe5cc10aab0df21672c7bac"
    sha256 cellar: :any,                 sonoma:         "a47510ed73acf0895276cf2600f3d81b2167f97a37b5c1e692f1811c0e00be14"
    sha256 cellar: :any,                 ventura:        "38380ba1b94a098c8bf7bb6de513d2356ba624847183d020f42dca351129abb3"
    sha256 cellar: :any,                 monterey:       "3c29491279fd468c89da8d32ac45e9664bec850cdf7e76c48babd8905c84bb16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2abe7d1717d409e2141b02ed03265b85aca8eba1acb04d9894d57f1a864bba58"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "metis"
  depends_on "mpfr"

  uses_from_macos "m4"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    # Avoid references to Homebrew shims
    if OS.mac?
      inreplace "GraphBLAS/cmake_modules/GraphBLAS_JIT_configure.cmake",
          "C_COMPILER_BINARY \"${CMAKE_C_COMPILER}\"", "C_COMPILER_BINARY \"#{ENV.cc}\""
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
                   "-I#{include}/suitesparse", "-L#{lib}",
                   "-lsuitesparseconfig", "-lklu"
    assert_predicate testpath/"test", :exist?
    assert_match "x [0] = 1", shell_output("./test")
  end
end
