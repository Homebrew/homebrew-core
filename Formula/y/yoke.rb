class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.22.2",
      revision: "a6a115e463a3cfbf6e9af9bde10e86a5c9e11aeb"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66c44fdaab242f3c811c4a47c30e52ea3b3010a22cbc9b99fd6d92b594a74aa1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a31e9ae01daa7b9ad4bb7592d81ac4c1d4066e12a8c33940bf0da89eff36bed6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "197fb747b7f24a17027a867b2f39bd27f21b3d89659c4688570d57ce6fdf9647"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6c5620a54d5d07fe6a6e41bca47b3bbf36b13407d81bf54cf13078c616af284"
    sha256 cellar: :any,                 x86_64_linux:      "d105ba557d804313b4f05074b413938873ce72aa2e29d0555088bd56fd298e57"
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
