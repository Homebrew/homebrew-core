class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://github.com/alvinunreal/tmuxai/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "324dfd4e55fcddb50d38fab3237d69bc618527c6f67e05426adc3ac3eaeedc45"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "aa2c1ccc8d4a306371964d97ac2d9c07cf88124bbca64b19db641bfa8d391e20"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f15c320e296e55229b090dbf01fc1e1683ab7f737db12533097405151ff2714"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f15c320e296e55229b090dbf01fc1e1683ab7f737db12533097405151ff2714"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f15c320e296e55229b090dbf01fc1e1683ab7f737db12533097405151ff2714"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bd597fe8817421c271d2a804bdadd130c3d54fe6b3ccfa31b797d6c4cd8fdef0"
    sha256 cellar: :any,                 x86_64_linux:      "a8c115a4471e1487e47ed08352057486e2554a73710f420c7b5d09debe730edb"
  end

  depends_on "go" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end
