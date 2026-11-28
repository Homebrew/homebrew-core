class Ryl < Formula
  desc "Fast YAML linter and formatter written in Rust"
  homepage "https://ryl-docs.pages.dev"
  url "https://github.com/owenlamont/ryl/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "6c005e39d0952dec7b937a0e9efb27a381979621a880ae6dee29777a641a94af"
  license "MIT"

  bottle do
    manifest_sha256 "0723c02dd12041a69272f02e2c6d1dbbfa70d6126020a5d9e816201ff35a0b26"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0a465e2aeaa73c8d8358b671e49d0d3aa7e8e618e976c77b98ba9a9898f005f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d89cfda8f932d4ce20af70d64cc25cfa09d30d429c8f814057b43db5fff3a440"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "efc348b8f226fddea45572aced8b2cdacd4c982139d588760698d1281c9c23ab"
    sha256 cellar: :any,                 arm64_linux:       "1fe834104297c70f54e6634aba6cad1a36b2d1eaea27bf9d9611fec1e8d76550"
    sha256 cellar: :any,                 x86_64_linux:      "54b7606053639d8320d2845cf76657b1cd0d68d3c7569d4aebf443e9366226a2"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ryl", "--generate-completions")
  end

  test do
    (testpath/"valid.yaml").write <<~YAML
      %YAML 1.2
      ---
      ...
    YAML
    system bin/"ryl", "check", "--enable", "ALL", "valid.yaml"
  end
end
