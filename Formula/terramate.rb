class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.31.tar.gz"
  sha256 "e5e43e7dbc0ab30868d47f0685941b1c31255b32ab21bfe765d6a2fdb91b3833"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2ef8cb6bb1a4aecca0b9b845e850f1db9714bb412ec6127908cd78aeeac8e90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39f9ca9940333caaaea18209cfb5470f5226d7bbd4fa1d71d55e3d4c1ecb612d"
    sha256 cellar: :any_skip_relocation, monterey:       "ebbbc9bd7fc31e9733f53d269054a396e18b874878c3a68e1ad6c9bc78e3000c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2615203c75d467cb676d200a3b60a65a4912a1e04089217fa7d3db95b75dd2a4"
    sha256 cellar: :any_skip_relocation, catalina:       "586931e4a9ff6b302b17dcc6a941c95cf3b6e34808dc224b99d22bbc9c13d641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c081f3b0ba06a5838b05b085b89bb80cf25f2008544a3ee773ea61af956296dc"
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
