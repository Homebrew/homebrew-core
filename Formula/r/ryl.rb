class Ryl < Formula
  desc "Fast YAML linter and formatter written in Rust"
  homepage "https://ryl-docs.pages.dev"
  url "https://github.com/owenlamont/ryl/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "4e652e61f38e9d563764774ac6d2e9eff0bde5641a350deaa2a94c861ad85959"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f04e738cbc236b63e570dc5a1baee05cc4a6af387bb6574f127e4ecbc59760cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3422c2026f6efea1f5b11be736e6d8902eb2037a95a53f275c9e9725a3465d94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "40de3b53ac36ae66e6834d4a0d522c53331ebc1789ebf79af4fdf36334456c2f"
    sha256 cellar: :any,                 arm64_linux:       "a800185a69f4af37ac936a37ddf78cc64c0ec7a469b528895b294c59a3f23e3d"
    sha256 cellar: :any,                 x86_64_linux:      "ddcd940735a6da054a7bb9040e7944f2c9b05e2bbdd4474490638ca9b81d95c0"
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
