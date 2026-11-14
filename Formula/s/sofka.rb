class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "e5a7647cfbf1dad40ee182053363795580bbc5c1441531222cb5e8fd2e92e754"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cc1c219a30d848a06c5e4b7d667100e4238b22dee1f4d59ff78c14082660937f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e99626600532881debe6128418a262f965602d4d3f737ad933b46d391844a4fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b132ca28dc23679198fdf54131beea087402434ead44a48b7a5bb4f4573aec0a"
    sha256 cellar: :any,                 arm64_linux:       "94e81a63a9b23a883512cd25974c2515a246c4d6b4a23aab91e15a13dd85a0a8"
    sha256 cellar: :any,                 x86_64_linux:      "9b95ad83361ca80a2d5192e0cacb95aeb724e34ca70b2cb4e7795a893770ba4a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"sofka", "completion")
  end

  test do
    assert_equal "sofka #{version}\n", shell_output("#{bin}/sofka --version")
    assert_match "failed to read kubeconfig", shell_output("#{bin}/sofka --check 2>&1", 1)
  end
end
