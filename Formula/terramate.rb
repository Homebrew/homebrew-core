class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "0db5d203d3bec2f2d7989d62e1cb173f0ca61687271ac91cc1d3ea79776c3e6b"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30196d80b86b76166167fcc915e728d2a8734ebb4b191b88c4ed50f96534a640"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02c5bac8609735ddcef1eb0bcc72161b9e0dcc795eb20615124ac98a8e15ca73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "795450d306c4f0d7974b1932f0176b6a417decbfd7421134ffd4c2e615ee9893"
    sha256 cellar: :any_skip_relocation, ventura:        "b2c93cba6fb75cd56e93122c15736891b11c4ed44459de45919131702947c0f3"
    sha256 cellar: :any_skip_relocation, monterey:       "8fde17d43e193dd1b89e3444737b49b8a64bd891b6866454c4c1a27e5276be1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee548260f7d12eb8eb4b550eb66a31a072057b108f211ef327974cbe11e16682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8303d880b3b5eaeea15b34bb12857fd867aade164bb15f2ce31ae36c4a32d7d4"
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
