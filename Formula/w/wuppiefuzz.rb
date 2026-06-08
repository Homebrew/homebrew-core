class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.5.1/source.tar.gz"
  sha256 "36fc2fade7e3a3901540c751f0e29c456ecb434dd171960e32a2d338731c09c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40403b648a9649ffa00439f8ff70cb50ac8b291a8ef133d96522523d74da0766"
    sha256 cellar: :any,                 arm64_sequoia: "da82823caa0b43495e7d62a5f2f4c504873d51beaaa4cdfcdd88a8873e9ac660"
    sha256 cellar: :any,                 arm64_sonoma:  "cd45177938db572afc15dd80364625f317f598804754d1407d530235ac8d9c55"
    sha256 cellar: :any,                 sonoma:        "e020bd8b8d9a207cb8c6b82e8367fcfb036ca1f55151797528fda27fab7c0422"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e3b32dabf15366d6b2d3115e3cbdc1163373eeab323a0e0d7c1ca8b8fcd8948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8710a9684a8847af281a7cd362a1df61c182962a5860ee96c646a96bf4416f76"
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
    ENV["Z3_LIBRARY_PATH_OVERRIDE"] = Formula["z3"].opt_lib
    ENV["Z3_SYS_Z3_HEADER"] = Formula["z3"].opt_include/"z3.h"
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
