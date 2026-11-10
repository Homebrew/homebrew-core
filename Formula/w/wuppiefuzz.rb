class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.8.1/source.tar.gz"
  sha256 "2b16baf2344f23cbcbbcdb3f1546c838c99ea76634c691d3cace2e6542014d38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c3b05fa456dbeff547c77ade1dc6970a37cb6d38578f9dfe645d608ff61610b5"
    sha256 cellar: :any, arm64_tahoe:       "b81f2345e74ff8587ffa161ec29b9b3b0bb9a1a82ba14c31c5081b6156d124a1"
    sha256 cellar: :any, arm64_sequoia:     "0ff4168d91bcf473e507b6860135f875fc76295c0e2f6907f16ecbcb8a641cce"
    sha256 cellar: :any, arm64_linux:       "9759b19dc6bfe445bb3f2fb52034feb96ce45bed8d447712cd6cab4a75612422"
    sha256 cellar: :any, x86_64_linux:      "928f4651611f840fba91c177ba5ba121462c2e90a82e2e0c576bc80f8734d096"
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
