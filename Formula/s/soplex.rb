class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-7.0.1.0.tgz"
  sha256 "138a5d8d72a5ee13c63369b6025412bcf166ff9a8b01c8a4cc0d3597fdd94760"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b153ee8d8cd091b59ad3d82e6e54ee01034a2d39d5ea1414ede78a90e3a536f6"
    sha256 cellar: :any,                 arm64_ventura:  "7eaba8b518f00dddf9df8efeb51e2958cc59778f6cadf433f9a3ab5b4c65b0fc"
    sha256 cellar: :any,                 arm64_monterey: "be3913747425772f85efe20afceb91bb4323b668c6abc2c199ed15f125e0d162"
    sha256 cellar: :any,                 sonoma:         "a0889090a5f6e159b0e310993aab4da24963b976587200f549f0bd80292eca87"
    sha256 cellar: :any,                 ventura:        "cdb8839f21f65ad1289af12e26d1ee4c43d1af1c50b4bd01df25cdb00a94df66"
    sha256 cellar: :any,                 monterey:       "a43df005b27514b3df9705666faa697eac51245bf430a598cfde4bdac7dd72b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54ede6ec6e0d4fca11bbf5e600cd76933567eb177f99843bc98c0360fc39083c"
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
