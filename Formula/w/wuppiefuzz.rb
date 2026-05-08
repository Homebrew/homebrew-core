class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.5.0/source.tar.gz"
  sha256 "f13052b7066be9c0b1047abc7c7a1ce9c5ed1139d52228fe2609b87853daa946"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4feaacb658e2c0ad8e8b83658ce0ef87a14d2d490cf2d853850e36efa9f72250"
    sha256 cellar: :any,                 arm64_sequoia: "951bfd7f88dd3b59c2bb242fed41e1450163c06c2fe3de821294d75de2ceb5c1"
    sha256 cellar: :any,                 arm64_sonoma:  "1ad59c6029f6c989046da3b02617f862f7b4dcffa38aefdea85677441c4c50fd"
    sha256 cellar: :any,                 sonoma:        "85b560780a233c76c551a6d0dd654e0a81c18382cb6bd808a57338fbca7a326b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "668c7fc5ef40eb1ade9d165ace3f480459806ce76c82e92547622b9830bb574e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bec331a44097c5601069c056b6e3ba948890b8b6fe646ef991f3be8ddf0ec48"
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
