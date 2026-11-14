class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "baa2571e3a8247527f056eb10e103069303fbba1f705adf6c2e264fe95f48ccf"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "94eff65593c1d9ef3bc4b9a87f8babc05a6e645ae5861a48a470557fdc46bb5f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9587a521e7d6f407cd493d65392232353335e80145d6e4369ceadd992f7da8f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9347e01dc5489d3c55ff087e9b40e69ca0d7ccb3b68ba249bfbcde4a1313864"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b3406e56c8e4a16006c2811f3b966505d2e2f0627a65a2c98eba12605b07cf49"
    sha256 cellar: :any,                 x86_64_linux:      "7913f7718f69c7f999d0c734adbffadb9ad1aaca81374814979c6f3626a6c344"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
