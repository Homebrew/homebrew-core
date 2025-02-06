class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-7.1.3.0.tgz"
  sha256 "ed51f0d82ea115a99323864832c14bcbf69ad563793d8b1c7413ba2d4c037c9f"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a1eeb27e45c704aba647605645441866769c14cb26ba3c4488d9d767cc69355f"
    sha256 cellar: :any,                 arm64_sonoma:  "a3a59468fbedd2c2aee4fe447401b6db2f8f5a4e4bdc05b3023bd06b24965de5"
    sha256 cellar: :any,                 arm64_ventura: "d1c0c5e16bfecc09bead6026aad5648c850fed5f3dfc3eaf3ccb03c35bcd0000"
    sha256 cellar: :any,                 sonoma:        "45656883aa0ab07c9932cff8a5d4a65ce192a6a3ae02f12be674d3a3a4793440"
    sha256 cellar: :any,                 ventura:       "c5752929287cf727a49356153e18768f6d25ad4c3c4b644e45724f2bbc109fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69aca653ddeac78bb7191bae12a3d0114e8138e026e6b96d17f94269249fb19a"
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
