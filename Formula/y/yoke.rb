class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.22.5",
      revision: "6d06638e669db834202bbd12ee3f2a5af1ca8774"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "46d271d9479ea4c5fd4476e3cc38fea13e1e133cf316a164eeb504edd225deec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e29760d5fe4671733cac375f5fe7232b8e853c0e7d7ba4081e08ea001b5bb760"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9df31bd3ddb22da9f2f91625af8edad797c6fb2ba08de60675ed9b89184edd73"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e8cd5cf18283f98ac0e2b878eda2fff225d2f8a73650783dfbf5479c1f6b7441"
    sha256 cellar: :any,                 x86_64_linux:      "3dd446da0de917f5a85469a3f99b46e7efebb6375387da2ffea0b5148301bfcd"
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
