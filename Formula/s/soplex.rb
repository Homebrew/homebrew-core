class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-8.0.0.tgz"
  sha256 "6c3d0a3a2a0f6520a7334d10eaadb34a2f258035e8df40abc18ccf862a0b892a"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cb16219c3ec40a99330682bfc6a1b8330965dcf1f38549d615c6c43f3f5a1253"
    sha256 cellar: :any,                 arm64_sequoia: "0af4252d52360c93ec4c81340376a50cc1d6a0f5ca36c03713d237ba519d39f1"
    sha256 cellar: :any,                 arm64_sonoma:  "2c08fc2ab9d1e6572bcd42bccb3abb311b67e6b4419f4f5dd4fcdf8cfdd318f8"
    sha256 cellar: :any,                 sonoma:        "ca1cc65b9f5ccbc1f7c0337025bf98ee2dc509e564421aa7760c3119fce90ca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63eba82c6bb4edcd6b50ce73bd744292ad5853964a43d8dd4170dd8efae6a468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ee8e874f5050b40a6175b14d6ed3266fb89a4652c1dbf6b2db3debccb6b760"
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
