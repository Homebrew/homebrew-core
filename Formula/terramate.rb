class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "2261b9b82df9e8874893ffdf7c9e2e572da22667c7f93b7851fa658ef6067403"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a12db34c79dd6a2545c213faf0b8c3d70d8c149ae8b8fe8abf548e304be9d963"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ee9cba2f61d296fd166f89d384861164059165624d042613bb2cd85227b74af"
    sha256 cellar: :any_skip_relocation, monterey:       "56064f6d1d7e56c3ec58049c3cc9b3c685281141df9689182bdd4915cf517106"
    sha256 cellar: :any_skip_relocation, big_sur:        "7603c6e18a69ad73a05766d425a88b4a5d41363cca055638624f3d15cf1ea6b0"
    sha256 cellar: :any_skip_relocation, catalina:       "603a9e1c7d663d60d01b50f2c21d2b64a0b3e6ee0f9e98fc212d4921dfa07ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34ae6ad8d5deca878b0996602f819ba708f0fa6be18b55f2d6f31170952f2ec4"
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
