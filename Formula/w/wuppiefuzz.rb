class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.5.0/source.tar.gz"
  sha256 "f13052b7066be9c0b1047abc7c7a1ce9c5ed1139d52228fe2609b87853daa946"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e59b88c5947525e948b443a1cc8997f6a0993523499867ceac2e79303bda97e9"
    sha256 cellar: :any,                 arm64_sequoia: "6d80b9346c503dba3b78b6763fb45336dd50a6e0c91b88c86a1b274756fe58ec"
    sha256 cellar: :any,                 arm64_sonoma:  "5a527e9930a2aa066ccdea78854d6ae31d39543a162bb0b5994ce81030d93b1b"
    sha256 cellar: :any,                 sonoma:        "9e7f5d40692a5cccd8e0d2029868492d7532f0e63811a3335ed6239a3761bc9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01b967a6836e5334ed7add55571e047a3b0d297393a4db33a386a59b39c0e985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9810f28506a6cdf172fb76749e625ec8975547c5b8e2ec23bf189d7f69d39dc4"
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
