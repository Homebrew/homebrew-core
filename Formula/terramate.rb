class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "2261b9b82df9e8874893ffdf7c9e2e572da22667c7f93b7851fa658ef6067403"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f7bf05d4ee5bef33c31b49d66e9327af2f1612b397afbfcbca0ca038c1df650"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd7647f11b7f8dc707d3402edbb541d87d43740e2f877c52e0d744729d965060"
    sha256 cellar: :any_skip_relocation, monterey:       "5f6cf2948d71967d697be3723441bbd1ed17444b8e31b40abe3c29102bf0f194"
    sha256 cellar: :any_skip_relocation, big_sur:        "a84aa656517fe53b244db765627a9e8055dbd2c930a5a84672fda6d414b0ace4"
    sha256 cellar: :any_skip_relocation, catalina:       "af75a80624056367b5b109bcdee5c9a3b7c3549215f54079d9a8da0412721062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d8aada490fa829d5b263fb393a6959455e53625bad39f64620d11e8c0df6336"
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
