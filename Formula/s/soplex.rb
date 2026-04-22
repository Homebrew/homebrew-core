class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-8.0.2.tgz"
  sha256 "d1634c0494d3b5355b611c3ce0f710dd19b9626f1ea65c822b668dc8abf1bf8c"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f59a426fa23a792285e7f5613ed122744a2937b6efad6cf06757313fe333941"
    sha256 cellar: :any,                 arm64_sequoia: "610928b8364ddeab8296216dafaa7b4df539351ffff17e382c1c0eb9f22b4261"
    sha256 cellar: :any,                 arm64_sonoma:  "71dcb224076a11019269a71b4b1b193259442b8e8b4405c817f8d6db2a9987de"
    sha256 cellar: :any,                 sonoma:        "4772f36ab163178669030ffc9011dae8d0716a1a51c180e48b216dc4500b5202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72da6eb5d410c88e0bac8cb9b87f63d95fbd4d0cf3834baaff93a6bedab49f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20906c8b190a3affcf702d3aaec37e3022328febab379273dbb1f60956e5855f"
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
      "-L#{Formula["gmp"].opt_lib}", "-L#{Formula["mpfr"].opt_lib}",
      "-lsoplex", "-lz", "-lgmp", "-lmpfr", "-o", "test"
    system "./test"
  end
end
