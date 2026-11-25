class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org", browsed: "2026-09-18"
  url "https://scipopt.org/download/release/scip-10.1.0.tgz"
  sha256 "fe8cfd15a03970ef45156ed56c6a4382485bd095e0e99cf7d7db87cdf8d47304"
  license all_of: [
    "Apache-2.0",
    "EPL-1.0", # cppad
    "MIT",     # dejavu
    "SMLNJ",   # amplmp
    "Zlib",    # tinycthread
  ]
  compatibility_version 1

  livecheck do
    url "https://github.com/scipopt/scip"
    strategy :github_latest
  end

  bottle do
    rebuild 1
    manifest_sha256 "eba9b1b342c49a7e58368652a152b9d5dc31d973dc83d740cad8037f57737ad6"
    sha256 cellar: :any, arm64_golden_gate: "9a480487b231be99eaf736a057d3b7b91a35f63fc1f3b8ca263a8b43972e581f"
    sha256 cellar: :any, arm64_tahoe:       "b1722131da3ffdbec2e0b485339b8e3ce421e24d2361ecb3a3c4d4d5c402ec82"
    sha256 cellar: :any, arm64_sequoia:     "376b0822b6e6c4e5c3b2d76a9558b77c35d2a61aace41a1936a4812189ed5ed7"
    sha256 cellar: :any, arm64_linux:       "028d7065a90e3a7a1dfa2103138fcf6121f7d591160a499aa1ec0d61006e0eda"
    sha256 cellar: :any, x86_64_linux:      "8c39fb7493d2302a7589ffa4236d4a34a95fbfc1fde723386e8ae7e014322ee1"
  end

  depends_on "cmake" => :build
  depends_on "papilo" => :build # for static libraries
  depends_on "soplex" => :build # for static libraries
  depends_on "boost" => :no_linkage
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "ipopt"
  depends_on "mpfr"
  depends_on "openblas"
  depends_on "readline"
  depends_on "tbb"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = ["-DZIMPL=OFF"]
    args += %w[EXE SHARED].map { |type| "-DCMAKE_#{type}_LINKER_FLAGS=-Wl,-dead_strip_dylibs" } if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "check/instances/MIP/enigma.mps"
    pkgshare.install "check/instances/MINLP/gastrans.nl"
    pkgshare.install "check/instances/MIPEX/flugpl_rational.mps"
  end

  test do
    expected = "problem is solved [optimal solution found]"
    assert_match expected, shell_output("#{bin}/scip -f #{pkgshare}/enigma.mps")
    assert_match expected, shell_output("#{bin}/scip -f #{pkgshare}/gastrans.nl")

    command = "set exact enable TRUE read #{pkgshare}/flugpl_rational.mps optimize quit"
    assert_match expected, shell_output("#{bin}/scip -c \"#{command}\"")
  end
end
