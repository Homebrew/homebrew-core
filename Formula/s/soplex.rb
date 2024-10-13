class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-7.1.1.0.tgz"
  sha256 "3b992b2c1a7275ab67b738da70e9432e6d1fe24cd8adbba8e975c043288d078f"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "df6053de6910965a8d977b5b9bee203dd154cb6b8eaad4f0cfc98bb02d40b409"
    sha256 cellar: :any,                 arm64_sonoma:  "7893d3c63f533676063eece580eef974bf58fdecf5cd24ea32e5bc0e3708dd14"
    sha256 cellar: :any,                 arm64_ventura: "6c5b245a25f1d8c3a2d548b65bf91c5baa112fe3bd4c25fbf5f1d12ad78d018c"
    sha256 cellar: :any,                 sonoma:        "3494b79c52ca4fc97e9fea5b3009629a876dbcc40d4225840e927ce9bc36c1db"
    sha256 cellar: :any,                 ventura:       "9240985761e54ab08ce9b370bcc46b0450d18e98a203938d4a3927a67003c8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c81cfbd5235370fc9cf2f0375e80cdb3943cbd0768fbb56fdad77a14ec2896fe"
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
