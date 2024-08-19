class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-7.1.0.0.tgz"
  sha256 "64916fde04e8d6bc8613e8703818fbce5103ac56610df86f569eaf9bad3f813d"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e7fbfbf3e6de73e99af5542559db81b740c3bb7d29bb9134b2d46c7be6f74d9e"
    sha256 cellar: :any,                 arm64_ventura:  "29986777cd852a19f24dbbbd31070e11a7c46b1bcbe82f1e39c1540d12a61649"
    sha256 cellar: :any,                 arm64_monterey: "e494d975f26884d2c9e2af9f262f0db8a73cfd400c6b5c5459803ab996abf058"
    sha256 cellar: :any,                 sonoma:         "e0b1614ca915cb18dd5787457fe9f44706b8277cc03895620047dc91d8807032"
    sha256 cellar: :any,                 ventura:        "618a17fd1e2f73f452728d72dc1a7963993b37a3d778196c17d552ced919ce48"
    sha256 cellar: :any,                 monterey:       "2f5ef1635df145550c9af5d1172acd529736cefbd475fe96f8fe1335c8b39251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c6e817fb54f69b301efa2efd8fdec9a2af15ac3ec76465cf87bea5a211c0c83"
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
