class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.6.0/source.tar.gz"
  sha256 "f22bd5f0f1f922dfa1481e752689fe043e49f68bb1139fab195359b388e461f0"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ecf9f532793558ed76c7602e8bc625eae1e1d0918afa24cf0d1715c528f07aca"
    sha256 cellar: :any, arm64_sequoia: "41ad460d67a0e7618f64c8645cbf6693c22fdb9cc390543bbdd1bdb9de21aa74"
    sha256 cellar: :any, arm64_sonoma:  "839f88a0d2f0629b9e0cc2b7b7910256595e9c75fe2da237fbc994923877b665"
    sha256 cellar: :any, sonoma:        "298a9a2c84f2eaff5b821e9530e7366c07e43596d3afee70e8004227b5c0f132"
    sha256 cellar: :any, arm64_linux:   "3d8a1873510193f44f9e4f44b5bb6ee8a383e9b5552a753158b8e4154df433e2"
    sha256 cellar: :any, x86_64_linux:  "0958a40581dbb98d977a42323467d212184fbb134d19a266c16760a92591c5cd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "z3"

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["Z3_LIBRARY_PATH_OVERRIDE"] = formula_opt_lib("z3")
    ENV["Z3_SYS_Z3_HEADER"] = formula_opt_include("z3")/"z3.h"
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: ["std"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wuppiefuzz version")

    (testpath/"openapi.yaml").write <<~YAML
      openapi: 3.0.0
    YAML

    output = shell_output("#{bin}/wuppiefuzz fuzz openapi.yaml 2>&1", 1)
    assert_match "Error: Error parsing OpenAPI-file at openapi.yaml", output
  end
end
