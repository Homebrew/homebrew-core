class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.8.1/source.tar.gz"
  sha256 "2b16baf2344f23cbcbbcdb3f1546c838c99ea76634c691d3cace2e6542014d38"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "001d5857aec873a9f3cb372eceb02abf3d3b6f3813c13e9be7ef8919a88e0563"
    sha256 cellar: :any, arm64_tahoe:       "31219042a09597715868dbc9705eb7c36c5e42525b52ffdb40e9e47f6bb196b5"
    sha256 cellar: :any, arm64_sequoia:     "37d9c1d0b9ed3629e849e193a4aca603e2645ea69dd4fd4c90018079bdd56629"
    sha256 cellar: :any, arm64_linux:       "0ae1bb3d601ca427be43b3c57afbc6c405cec90a958f81bf6aa883192f76377c"
    sha256 cellar: :any, x86_64_linux:      "7f280993fb25f08acebd4c9467abbd60d779ffd5170ae93d81825da9b68c64c0"
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

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    system "cargo", "metadata", "--locked", "--format-version=1"
  end

  def install
    rm ".cargo/config.toml" # macOS `-stack_size` flag breaks proc-macro linking
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
    assert_match "Error: Could not extract server URL from API spec", output
  end
end
