class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.22.7",
      revision: "2adf51010d4f6f22eae57b959b625b27c90db072"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8e9a481ff4877f68756f2ea8ae33bd08b66801694a7179d67e4526f7861f30c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e196dd7398a0447b3a588506833efceee8642a66d0f2cd7522e12c1f2315e307"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "46da207363ff4c353e24cded8eb5d20eaae77c9f267d024f3e32ea41c93a974f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0040f5916d770e5537aca22482931abb0788d6fbd6f63b0ea496586a8e57d1f2"
    sha256 cellar: :any,                 x86_64_linux:      "fc3dbeee7be1926ff889c3ce0d98f5103c4e6e6a1f72d3a50b87b95f0789a83b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
