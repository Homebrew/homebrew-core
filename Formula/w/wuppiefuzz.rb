class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.4.0/source.tar.gz"
  sha256 "2640d4103574eaa065b66f074d98562e5c8b296bd8288745ac5aa36101e262b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "520e4b31f8f84d00dc6023d41828be1806d6e4cfaadd97a317bc63a870bf36c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1465609be1311e6c07ddad7772ab29cdbe9c9db8ebdd6962a6485e1c5ee8c266"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06baa0d6ee5d0a72e4133fbd3f19285ee24e363f879ea2e1bfe28d34b04afe41"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b1b0514db88fec95a69a8f01a252ecb2d5abec18ae4a9b89c6abd298316c185"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "137abeff845b9d38e922d48114ebbb4dfd89e41d87a61594d06ea7ca3906c2a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7c766d42f94ede7db7e2a41128522362a9caecc6457d48928b241a45ecf1c16"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "z3"

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["Z3_LIBRARY_PATH_OVERRIDE"] = Formula["z3"].opt_lib
    ENV["Z3_SYS_Z3_HEADER"] = Formula["z3"].opt_include
    system "cargo", "install", *std_cargo_args
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
