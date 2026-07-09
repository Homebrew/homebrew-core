class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.6.0/source.tar.gz"
  sha256 "f22bd5f0f1f922dfa1481e752689fe043e49f68bb1139fab195359b388e461f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "20ee922f4cc46c8fcccf3fe242a7bca7e0f0002d6b51d3c5c318bc3d528dc2d3"
    sha256 cellar: :any, arm64_sequoia: "9447a3a78f3f66977029e8a8ccdc8f1b7a5f67e6477ce914de490ed12e9515a2"
    sha256 cellar: :any, arm64_sonoma:  "a5dd42edf2b8c2ebd5ba43f003cdda487a7f674fd710321cfb6b19ba2eb08048"
    sha256 cellar: :any, sonoma:        "99b99d32ce32ff4bf8a525fac7abc746e0636130a7b32e991e078b360d64d764"
    sha256 cellar: :any, arm64_linux:   "5a17e28e65d7fc7cdbbc3ea8f28b01d45231b94caa1478ea5a6dc2aca5519ec9"
    sha256 cellar: :any, x86_64_linux:  "9ad2776b388945f6c802a22f2ad6e0ad7c7837095b5b5f501038d1f30dc5600f"
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
