class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-8.0.3.tgz"
  sha256 "14ae9ad62701d2d5f0ac8a93ed4805b44c94440123d051c7c88bb862013f2cd8"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "683aace3a66e35fd99172eaf1608253eff103abb7fb83e2d47a630f88f8ce620"
    sha256 cellar: :any, arm64_sequoia: "87d025017dd3ab6c7f793a27b7fa7f80e8e06c654eeb40322339add7850d9e9c"
    sha256 cellar: :any, arm64_sonoma:  "c0fae1c0717700b652668c2aedd692ab1df6af0dc3ddfe4bd195004c16ea5c7d"
    sha256 cellar: :any, sonoma:        "d1f5576aa2d11cc6cef6652762ba52665e682ba8e2bd4291ce9b95629ddefc18"
    sha256 cellar: :any, arm64_linux:   "46ba78bed91f5158572392c78123c3435fe06c1036aa753e2c55f80f70577a15"
    sha256 cellar: :any, x86_64_linux:  "f8ab7d8bb3208db083556ffa18526e110ff6a72f86a30581d077bf541669b0e5"
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
