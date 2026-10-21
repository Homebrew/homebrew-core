class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.8.0/source.tar.gz"
  sha256 "8405309fc4b51fbabda282540c25605a00e741b4f3c0c73fe8e7a594ed23ca9c"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4911d8c8538fa900ed5b1acffc0edf3e7a95c001e60218e8d138c7da4ca63e80"
    sha256 cellar: :any, arm64_tahoe:       "49d1ae2b76faa6ad0759dc174268ff5542a7405ae7bfd65f2a032d9fdf6ad5a5"
    sha256 cellar: :any, arm64_sequoia:     "afa6ffa3eb01a5ffb3926ac945c5249a8f26d79bad0e1d14eeaf0dfc9365dd07"
    sha256 cellar: :any, arm64_linux:       "56b1e7ef6fbba4e74dce403604703a8ea9c1257a01650517c76a920fea28604e"
    sha256 cellar: :any, x86_64_linux:      "0e1644dbdd61027fccbf79d884914a0e2ab880ece310594f110eb02879ee9239"
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
