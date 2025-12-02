class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.18.4",
      revision: "69b025a4a06fbed14779e907f53929622cf8812f"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27bb4be86e8c80943eb47a8d606593a757deb9129cffe9c706f750dd3cd94531"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f4562206b7c55e37efa1abb68c3653e9bc397b9a02a7b66d55a809955c4d9e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "183bb69d950211f03ec2d70a7488a6cfe9da6c6ba6f5116dcb5a31958775f614"
    sha256 cellar: :any_skip_relocation, sonoma:        "43c9d057f363a72dde937981ada64b5a1d2e4be1ea04228892f6a6b696627123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8b3b6745fe294b80c8bfb7e826ae012f26548d402d8d29250490e3b47e42015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "821133106635211cdd8b3073d869f5803feb8440667d5375dfb8dfa69f7adcb8"
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
