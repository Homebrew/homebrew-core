class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.14.1",
      revision: "121f0cd99cbc833b335b7dec0b8b37dacd7f7ed7"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2073afab58a8e5d429c5845684cd3e5a5aa9f895d64fb99bb668f991ad531025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f15a1ce4ca47398598e4420f2443061742ca34a45693ce2fe451a7a578fcf03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ce9d485fba2038c3e51fed2d95bce1641781476a94083190eec3afa11fe48bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec5e8a05b747d92b206ee892a4c41a0508cfd4ccfd66516593cfef8edf7815be"
    sha256 cellar: :any_skip_relocation, ventura:       "d33e14723ec00b72510389a1e8f9818c30ac4565cb59e31d3352b1edb221b68e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2b03669db6c51c861493657e4dfde39a090a4831d115be97415dc91f4f1e335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2837a949e615a1279dbae1e26bd878929ea8af60ea34b863c34494bd2240249f"
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
