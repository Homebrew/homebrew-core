class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "af229ca68c8f62f4534286d6e58b3d4b165a68ad04ec2bf48b55f9fd011964bf"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7544f7bb9c52e0d7265cc77155bdc396cf3fc744ff30a583f3ed59e98fbb07fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "888e02560af60600ad140e3b122a04ca3f99415a737380754f20c4a4e7c16439"
    sha256 cellar: :any_skip_relocation, monterey:       "b5e89cd79c90f583fd10019857bb34a4b71c40172872eda00101c33626793eee"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcc4a8b14bda298f531828a87ded9aceb98b7ed07d720fe51da573e4406df5c0"
    sha256 cellar: :any_skip_relocation, catalina:       "bc9ab0497cf80dd0f39d883625ac43fe1445e3e91d816a080f5963d1389fa61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41830628bb46aff9f4000973f60d406fc5b5fabb17934a26888eb1d944a5da4b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
