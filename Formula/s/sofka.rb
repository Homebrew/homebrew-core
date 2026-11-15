class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "94c13f7678daea8c379e90957587cf7a637b2a706aa0b9cc72d1ae8082d496c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d3fde263d5192178e03379a8192dc2c56bf3b59cea7bdc5996e9b8af446c4a01"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "60200c970e3935190ded52e5e744a13d946f2e448443e17973919b5dfbfa64cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f724e68e7fffbe8ef158bba536ef93b014bf6f8aeef8ab265a311cd3fc85f94"
    sha256 cellar: :any,                 arm64_linux:       "eff024959d650568952cafa6804008ad36fffab788c5a158d3ed2ab3cc9d8751"
    sha256 cellar: :any,                 x86_64_linux:      "672b3da6cbdea93fdf9badb2c53142a382048a4feaa30f127f089c173b1ee31a"
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
