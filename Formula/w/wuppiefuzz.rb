class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.7.1/source.tar.gz"
  sha256 "93e3c143b90d552a2620211b866176cedfea58d263bf75331f2da550a55996f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "87a928a6982793d4a1d9886ca9a93283f64cc141cc34566858ceaef27a7bec61"
    sha256 cellar: :any, arm64_tahoe:       "9c262ae160c959c3a173a1cdac5e8cc8dff007d76b2c9dec36bc18d6b0ffc933"
    sha256 cellar: :any, arm64_sequoia:     "5027f7c0331bf2f97d6ad18807862a9fef576718524fce430cc94afe05b375a6"
    sha256 cellar: :any, arm64_sonoma:      "fd84fcf149222b32a825730a697d969e152e1837a83288041ae82fe2c6a28aa4"
    sha256 cellar: :any, arm64_linux:       "30dd3db10fa7bb455866d9c55540b84534f5115f5503558c1192425028c8bfda"
    sha256 cellar: :any, x86_64_linux:      "bac2b56b09e4d0357d4b02e9265c6df2febea55021bda69a3b04352c4a86919a"
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
    assert_match "Error: Error parsing OpenAPI-file at openapi.yaml", output
  end
end
