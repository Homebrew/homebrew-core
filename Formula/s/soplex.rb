class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-7.1.2.0.tgz"
  sha256 "3808d72889272c70c43170722e2ebbc21bb787e164fb84df562d713e395744b1"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "45235723e234e61c4eb3dc47a346ed74bcaddb69ec7aaa650a09489edca5ac90"
    sha256 cellar: :any,                 arm64_sonoma:  "471465c8aea235e3c3725da224fd42e3603ce7d1d99331d08031a982a6fa2faa"
    sha256 cellar: :any,                 arm64_ventura: "0bed4d5eb3b86f2273ecec115cddf5833398b59322b0f8b323abdf9fb6e605c9"
    sha256 cellar: :any,                 sonoma:        "640324db76c4fac154a965f266a786ee91e89072b9cd022e322ae7cd0a2aba14"
    sha256 cellar: :any,                 ventura:       "84078b476b9c6ccd290c50193b07f9746a9afddc6a950011f0eabfb29f493feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77fe1c28b376440ca6b197c3acdce9a43bb3cae42c6a334c7a648ade745b587f"
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
