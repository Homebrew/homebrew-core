class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.3.0/source.tar.gz"
  sha256 "45d112673c633684459651976119fcb4d8a7f1a74b974ad05de61481b686f49b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31d3ac521302f3eb809fced503becb69569f12d51f23c9eaf772370d2075ee45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6fa5391cc83fb00c73315e855bf90da244702f32b9edba1b8f9b74c81df56b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4a1279ae32e5a36b8cf01a567cebda90642bdd7ee946507a545aa77807629a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5b744520db48662e2e061c6934462fd4e4f509bba4d5b7612ed23c0e0bb3b11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b26c23bcd612a6265c81b03255a309f9507ce938e36892c33a06432dc812d85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb8158f0378edfb4a61860668181e720fd4366640ec44305929a0b5018e7f87"
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
