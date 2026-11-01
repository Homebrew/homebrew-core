class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "f1873049e7dc76ce3ef072ee8158a12f7fe2db6e3268e55e6da47a99172babaa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d5d9b2154d65cd8b452ea41beab375675b36c933f8a2bb760f2b7dbb470a537"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "88af36c45708ff00b2b1c2649fb20a3332204ad45155965da29cfda11c9a80fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06ed4bf9f345911acf4ebc2c0951369ace95f12e08ac79e83ee9da6a142dc20f"
    sha256 cellar: :any,                 arm64_linux:       "401f040ec24281e1dfd3fead5772aa7ef629edd88f526810da88af8c9e1c78b0"
    sha256 cellar: :any,                 x86_64_linux:      "415e3b616d33525f809267fe316f144464ab0c9d1acb821d4b3b234c3c6a1674"
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
