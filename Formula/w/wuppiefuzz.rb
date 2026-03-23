class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.4.3/source.tar.gz"
  sha256 "283450c7b4d9723a0c3e67e537cddb1d4d6d77e3d93e5630dafc8f071ce79cfd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7837adad1781bd07b850695d5ce6ddefc967fcec2d2b8ddbd993ac293e81360"
    sha256 cellar: :any,                 arm64_sequoia: "9ddb9a4fdf7bf8cf8faa96fa507ddd847b71d828da71f5b5667e1feb20a15f8b"
    sha256 cellar: :any,                 arm64_sonoma:  "823b10b0b893600991d1e90e66fcb8c6116a54ab824114c1057bb5cbec4f2ee8"
    sha256 cellar: :any,                 sonoma:        "17992da78d913a54fe9eaac7d84a4482e62bcff0b74e7705cad15e3a241aa587"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd78f339f6b24585f6eeb80cad64ed0d3181d710448bc4c5a2f7af6c5dc76b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42fbe354c80c59a2e5356107cecb887a6ed495db5dc6868032daa75ef4a1dfc5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "z3"

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@3"
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
