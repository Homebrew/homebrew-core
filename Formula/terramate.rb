class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.32.tar.gz"
  sha256 "b95712be58b482364a8292a785fb418eb3f589f80d9b094ce4d68ab339d6ee1e"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f32e4611706b35477401562c1f12e2331ff6b2661e8cb2df84133d172043d31e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ac980e59fb125f91ea592255a5466d5d9c31a83323b3eb7a91fb41ef5268111"
    sha256 cellar: :any_skip_relocation, monterey:       "fca4c11d953602d896dbcadc4d14be276d6b49050d2577997eab82360642e42f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c236d747c3663358b7ee5b157733da98934e8c86fdcf24ff92aea5c4ace772ea"
    sha256 cellar: :any_skip_relocation, catalina:       "199578e1f915127b3b5645a06bec4d5722acf22e2449a6439c45b0144374357c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108d07d3aaa16b5882e267366ac3ae6e51951746e6c0144a5d5b8ab27e5e596a"
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
