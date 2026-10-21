class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "91af8abe671c5c79d0eac7b2b045ca61ef9023241edefd4d636becbedcc0ec0f"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "91b278a1f7f3574751118534365ecd630b8e0950d86cf121c9bb55e82df104f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04f8e3baf1debdca2eb7919587f9619fcd94dfe9e5349dffb10296298f905a00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "034f22190c9780c700fc8eb5a89e503b6fceec51e6136fd2ee4cd12ce6590b92"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bce3085c93ee397d2e49643dcbb21c7f4e103d0fb24175fc711d2cf7c4b53c47"
    sha256 cellar: :any,                 x86_64_linux:      "24096eb3afedb99ccbb1f5a81a7d2ac27cb33201101ba890031fa8a4a1f51dbd"
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
