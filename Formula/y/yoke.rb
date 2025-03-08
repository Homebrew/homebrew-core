class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.10.3",
      revision: "ca69888cba2ea273d5405c5e9c82245abf7d7bc5"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f74c36b85ec0a0d4cae40548a6bccbfb9944d3545f7815e6a7375b2d78dd8e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f74c36b85ec0a0d4cae40548a6bccbfb9944d3545f7815e6a7375b2d78dd8e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f74c36b85ec0a0d4cae40548a6bccbfb9944d3545f7815e6a7375b2d78dd8e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5f5707965773d72190514ccca9b4ef912dabba0ba62fda5cb9f1387d2e572be"
    sha256 cellar: :any_skip_relocation, ventura:       "c5f5707965773d72190514ccca9b4ef912dabba0ba62fda5cb9f1387d2e572be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb197aa2513a973c30655db2788e1f9a22b3883f061a28b765c803c77f548493"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
