class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.14.tar.gz"
  sha256 "91890868268ab2fec99dd34ebf7521e10dc714193b008cf5a1e37a4738bcdf97"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7173abfd7e4acfa4b2020252926e03c7b8376bab0b27fe2add33462be422a647"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fae4f8cc88349678055159a9cb6a762a3aff81a55dcc3db741dddf52505b3ca1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7d86eefd816c7628043ef377a61f71fa1c616b7e74a6775a09c6bcba65cfaf13"
    sha256 cellar: :any,                 arm64_linux:       "10cd18a46b2cdde75f29f1b438ed48da7a1db0f306639c21f8bdaa27e6b93fd0"
    sha256 cellar: :any,                 x86_64_linux:      "f71a499a0abd3f9bddf268625554cc0a9ae98023de9c58a4eced8cc57cf94800"
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
