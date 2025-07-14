class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-7.1.4.0.tgz"
  sha256 "cd8d98aa1f70e828761aaaad490731c95fe29d7f4d045d80ba84f6b42e5fd13b"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3dfb2a5450d7294b68d96cf56aa9bcbcc7f9a8c6c8be97c206ebef211f6656c8"
    sha256 cellar: :any,                 arm64_sonoma:  "1ca9a48145d8b796813cedfd98fa50d4790bc9df451fb1f9ce8157f53c9602ba"
    sha256 cellar: :any,                 arm64_ventura: "08c6f3e7df6484a475a46ae20e6b3e69eb9912db1548d56faf72646cbdd98b9a"
    sha256 cellar: :any,                 sonoma:        "3e97490be640331925d970d69efec15f7bc16848a30be716570ef64d9592949d"
    sha256 cellar: :any,                 ventura:       "3affb0ea07f6ddf23aabf151e309ad9ebff8b44479b9039a57d76d1a06fcdb1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2461743019db4e58c22fd21b14106246fd7daa3884526b217dd6af6d5c71a28f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c24dc2aa0400865ff4bb6b2172b33416aa4bde18b3477e07bce938c8f7d33ef"
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
