class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "9f3c8ac651fc59a9b0b7f7ff8a5ae5d7ee4af919ec9b53aa8dcb4b9d4ab5eac0"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ba58537072def697abf086ef5a2b65ebddc9c42d874d25584d2aac2b9f98785"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "197505705a4b5d38e37160d4eb5f5cb70a04674abe37f1aee50f91af7a23537f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cecc5b3bfb43961a15155d67b9a6aab8fc87b328d6d4d39daa47fa1883a5f97e"
    sha256 cellar: :any_skip_relocation, ventura:        "8704be78b6b9f45f6824a640491a5c72ad29e85593d767de9837d43ee2efeb9d"
    sha256 cellar: :any_skip_relocation, monterey:       "67443cd7e1996f90651943a500df26b96dde190cc3fcf692c7e05d924ce01a54"
    sha256 cellar: :any_skip_relocation, big_sur:        "695a3af1cd99a61db1d7d30c5e18997c2d5e3d6a48b0a0c6b8e65f98927d74e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4322e06aa814aa2b755c1ec8f62b200336b5af7b199e104b521c5817b44802db"
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
