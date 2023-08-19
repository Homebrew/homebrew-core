class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-6.0.4.tgz"
  sha256 "ecc0654bc4ef660006a3a59d9ca99e80bce5b2bd2d72dea6ae183abb81e1fb95"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ad3c7c86b3917a49700b67367fdff49afec3f94c304070279a89e8137fe4fad7"
    sha256 cellar: :any,                 arm64_monterey: "d31df9bed595196c8ac336e069b804ce9a37641a7ef0c068b0e0d82b92857324"
    sha256 cellar: :any,                 arm64_big_sur:  "40dcc65bf2cdffc354dcf5b9e5e53e13f61209a006de9dce985f4be979d033f8"
    sha256 cellar: :any,                 ventura:        "7f1567a37a86cb117f6612555affb3171dc0c05249e22b96927e5592aa320660"
    sha256 cellar: :any,                 monterey:       "12208ff4d64b164d1593e4604a15f2924add88a337e9ae2e20f686cb27bb1781"
    sha256 cellar: :any,                 big_sur:        "a7fc02385e5d80861c073923b4c0b62efc133606478f3b998cae478462c7cdd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18e228b4c992e3228ff3bb6a20df26f0dad8ae298ee52f2787cb629ccc12483c"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "tbb"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
    assert_match "problem is solved [optimal]", shell_output("#{bin}/soplex test.lp")

    system ENV.cxx, pkgshare/"example.cpp", "-std=c++14", "-L#{lib}", "-I#{include}",
      "-L#{Formula["gmp"].opt_lib}", "-lsoplex", "-lz", "-lgmp", "-o", "test"
    system "./test"
  end
end
