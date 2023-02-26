class Zimpl < Formula
  desc "Language to translate the mathematical model of a problem into a MI(N)LP"
  homepage "https://zimpl.zib.de"
  url "https://scipopt.org/download/release/scipoptsuite-8.0.3.tgz"
  version "3.5.3"
  sha256 "5ad50eb42254c825d96f5747d8f3568dcbff0284dfbd1a727910c5a7c2899091"
  license "LGPL-3.0-only"

  depends_on "cmake" => :build
  depends_on "bison"
  depends_on "gmp"
  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", "./zimpl", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "zimpl/check/expr.zpl"
  end

  test do
    assert_match "Variables: 10   Constraints: 23   Non Zeros: 56", shell_output("#{bin}/zimpl #{pkgshare}/expr.zpl")
  end
end
