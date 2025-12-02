class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-8.0.0.tgz"
  sha256 "7b69b4a3dad3c85bbffb30f1a7862e441b9c2984c063e60468d883df0ca0cf28"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "68059b60d46e80cf6c28d41c65190e6a0198421dcf3c2e7eeecf5c1890fc6e28"
    sha256 cellar: :any,                 arm64_sequoia: "50ab905ad91e6ceff4c92fc4851705374cf20c928737ff83719681cd9cd1b1d2"
    sha256 cellar: :any,                 arm64_sonoma:  "3238afa7cad64a68f290efaee60ccc9c2fd2f3ab60a3b1f258c24e091576c069"
    sha256 cellar: :any,                 sonoma:        "78413d50a860c9da05d5b4504c57d7a8e1aeffba6c6109b3d5a1f37783eb8997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32d147f2be34f87c6654cebe431867e661840b5b45675b73ba1e8da41b2d6a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc647fe802d9c62b04aa8a7a5cc46f67b60b6291a4d511fc016919b3a5193336"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"
  uses_from_macos "zlib"

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
