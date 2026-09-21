class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/", browsed: "2026-09-18"
  url "https://soplex.zib.de/download/release/soplex-8.1.0.tgz"
  sha256 "e7daa1725d9cf01ea1f0a548fa396e7dcc945c1e81af626c2c98503b0c4e5990"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c2ae4c15de4db6494a960143f7c16bf8f9a3f297dfff54b21a620f54a0bfa799"
    sha256 cellar: :any, arm64_tahoe:       "eac15c7cba992d07b176eaf59f148fe574cc41b9a65dfe26c515146588bd3ff5"
    sha256 cellar: :any, arm64_sequoia:     "58bd2205aa57bb30bebc87bfa158895c4babfb015813cdda9227c5a50b3fb646"
    sha256 cellar: :any, arm64_linux:       "af25fc2c56ba32006dded4a0f56a5762675a274bde8de7dfc2349d32301064cf"
    sha256 cellar: :any, x86_64_linux:      "ab09bb5a1b033da0b6c9d430f3d90b902108585d6a3d51723a81a90fb9067d0f"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DPAPILO=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "src/example.cpp"
  end

  test do
    (testpath/"test.lp").write <<~EOS
      Maximize
       obj: x1 + 2 x2 + 3 x3 + x4
      Subject To
       c1: - x1 + x2 + x3 + 10 x4 <= 20
       c2: x1 - 3 x2 + x3 <= 30
       c3: x2 - 3.5 x4 = 0
      Bounds
       0 <= x1 <= 40
       2 <= x4 <= 3
      General
       x4
      End
    EOS
    assert_match "problem is solved [optimal]",
      shell_output("#{bin}/soplex test.lp")
    assert_match "problem is solved [optimal]",
      shell_output("#{bin}/soplex test.lp -f0 -o0 --readmode=1 --solvemode=2")

    system ENV.cxx, pkgshare/"example.cpp", "-std=c++14", "-L#{lib}", "-I#{include}",
      "-L#{formula_opt_lib("gmp")}", "-L#{formula_opt_lib("mpfr")}",
      "-lsoplex", "-lz", "-lgmp", "-lmpfr", "-o", "test"
    system "./test"
  end
end
