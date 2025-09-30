class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-7.1.5.0.tgz"
  sha256 "318cb631a94407a539ced835d56c038a15ce095affaf33cff6f9310512c62bb8"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "198fcc85981fe0b9a68cf62b102c525be5b270cbb4c51f5bb5ca1db3b9cafe8d"
    sha256 cellar: :any,                 arm64_sequoia: "15c77602e5db1c983e11a1957d6e43efb00947507dddbec9b90154c72cc2a2ea"
    sha256 cellar: :any,                 arm64_sonoma:  "edee40e0cda63129735bf2b3a024e550b3617e7fbbed903cf0d2e464b8371101"
    sha256 cellar: :any,                 arm64_ventura: "2261b573255984583322cc6988df39fc295b93c3127a422f7524d86fcba3dab2"
    sha256 cellar: :any,                 sonoma:        "8b2fc2fee625c90a061537d1ae43ac1c3610fb4ce7960523eca29ecc14277a34"
    sha256 cellar: :any,                 ventura:       "b580c1f7f184ab963bb0d1f182e5b0244f21d933bf165fd5933eba881c1332e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "612d2bfe2cbf24c5f7e20982ab93fed65672c62c3d23f763ee77ef9d844996de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88fc19bc3d34b63529f6a8cc52f1697681b5ed0d818d9aba879ae3b9aedbccc9"
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
