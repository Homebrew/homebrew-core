class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://github.com/kunchenguid/treehouse/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "c8941c4df4e3193e7a27698d521f2f3d86b8cf399cd7ae8206395ee2920ce4de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e103ca195214a5a6c4f5fee663fecb124bad136d5c498ff6194c678c45b759b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a48a5237c8b3ff623a2ce8fd2823d7531693f215192cc27838054485f0deaab6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7aa6f663ed8c36f98e77f3769ba992551826275d4314d8f3919abe339679ae3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c99409e5d3e04c59ebdab7d92a59f076b0125fd162ca5e58f5e18ebcb2e7882a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7e2867f2dc165ec2202322e84785b99ea0e5d2ea3b752566728811b13bc042a"
    sha256 cellar: :any,                 x86_64_linux:  "90de3a03e041535ca36267eb623aae9d0b4a69a1bc9f09ba6dce6c2e3c096fab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    system "git", "init", "--quiet"
    system bin/"treehouse", "init"
    assert_path_exists testpath/"treehouse.toml"
    assert_match "max_trees", (testpath/"treehouse.toml").read
  end
end
