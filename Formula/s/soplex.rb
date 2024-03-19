class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-7.0.0.0.tgz"
  sha256 "0fc007ef4f9a4686d119d0d2ea5f6df13903f65cb3afb22e5b5ec16054037df8"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2824d050a8a49639fe9da5e252390883b91b98399e0d4c17dd3223e97e9a36cb"
    sha256 cellar: :any,                 arm64_ventura:  "9239b621c59f38a88df0a2147e49a0bc603ca2161ff0c7332e051f89579f69a1"
    sha256 cellar: :any,                 arm64_monterey: "c8bf17667f01645b301a348019e5c7a0f2bc3087c48115116013f26edfdf3e67"
    sha256 cellar: :any,                 sonoma:         "07e01170bb7e0293d71f797b038a44bd6afb76fb4aa8ca20ab3ccd4e447c0765"
    sha256 cellar: :any,                 ventura:        "5dbf43a7aa679a983fe1244522fbbe13e15f60dc02d40b1a10a441809d330825"
    sha256 cellar: :any,                 monterey:       "bcaf336ea2f6c1480d061509a8a19aff9cff08a61997c8ab6a73c8ff10bbc2d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "797695041908e965a62c6e764f1cf9be5767614fa0becb7f63ea5fb2595a9ae7"
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
