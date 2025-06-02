class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.13.2",
      revision: "8c1b4e1e51e1691be613e9ae7a5b5d97ab9ccb9f"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24cde1712f375defe89431c1a0816b5e5e6682262b865a9cc38a3dba21de4953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6181f5082ccc8be3cbe6242d1de395133ab09d196df0be33e25d51b1ca809452"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffdc82520d8025f0cd962a98d1d36fda28c2ec216d2daef2f9bb8e8bf2b5a3f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d1dae56dc178287158000791462e274c1e027251507750cc16a2878db865279"
    sha256 cellar: :any_skip_relocation, ventura:       "95d72a0813ed4d4c025590551a8b86e4ed528baffd4c45b399840ead9cde60b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e954151626595871681393d8285d31885f6766c1871a72724d0873c3e74fe3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "410207d7869cfa6c5cd6aee73a82e622788b83576ccccecde2b727b5308b2279"
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
