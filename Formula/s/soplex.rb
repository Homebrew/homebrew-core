class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-8.0.1.tgz"
  sha256 "f833af9046d33c51de653effee38cca1fe99ba84a2ffa243eecdd8a5f22998e2"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6b30073cd1aae2cc5e7d43401b8a9a21fd21d62ddf7efe2a73e2fc31bacd45f5"
    sha256 cellar: :any,                 arm64_sequoia: "a33f607da757db612a384dd7b052d7ce8a09d9bb7a948263dd44a3bcf237bf38"
    sha256 cellar: :any,                 arm64_sonoma:  "93067dc7706ae314e3c892aae19081fc5faed06d88714a0b06711f18e44a40ee"
    sha256 cellar: :any,                 sonoma:        "29c87b1dc260aa6aafa317f50f8e0fabe17036800915bd9b764d5e314c20db2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22b7daaeb89051d2162e6ec33169ba933c121cae9f4cf37ee2cc938688ec5f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ceac79de714dafb666899c3a8338f924ce59b5cb9feead41bc1bbc2044513f0"
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
