class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-6.0.3.tgz"
  sha256 "357db78d18d9f1b81a4fe65cf0182475d2a527a6ad9030ac2f5ef7c077d6764c"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fe7cab6cf7d72f3600615567c5d35928f64100a894aec88c036a1b74ae8ebaef"
    sha256 cellar: :any,                 arm64_monterey: "871d364891d796e3a9a6d6c9892f6f5eaf78ee931eb9150aa8ccdd11dfa84f3a"
    sha256 cellar: :any,                 arm64_big_sur:  "9c4f2020273a628be567632a3da99f20fa1c9d40928e92069c3b9e5aa94fb129"
    sha256 cellar: :any,                 ventura:        "32914581bf7e4ebda8bab2d3d1be0ae0ef8fb2c72383fc46f81bec2e73f7b700"
    sha256 cellar: :any,                 monterey:       "749d4059dac1f07bcf248346ac94dcb0367b0d996779a28cb2df629c63dfb8dd"
    sha256 cellar: :any,                 big_sur:        "a34f1994cf2e258d82eede007619d98e62997670289e00f6415ab50d14215019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fee3c886e05256b18d65755ed273701030f604aad30d676b7e72b2f5f167af9c"
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
