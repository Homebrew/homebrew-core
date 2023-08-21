class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "6034479c888eeeb109e8052aaae8a5d3b20ef7eaeb946a887b578336b64e2065"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c4d9339aab664761b7a4b0cfc7d5a8843ee6d04c92db6b47bcf97910c921995"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c4d9339aab664761b7a4b0cfc7d5a8843ee6d04c92db6b47bcf97910c921995"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c4d9339aab664761b7a4b0cfc7d5a8843ee6d04c92db6b47bcf97910c921995"
    sha256 cellar: :any_skip_relocation, ventura:        "e7c03b4b0e0a0f8c1f2dfe904544025ef684d37993a25f2d45d8430a9aa88e0a"
    sha256 cellar: :any_skip_relocation, monterey:       "e7c03b4b0e0a0f8c1f2dfe904544025ef684d37993a25f2d45d8430a9aa88e0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7c03b4b0e0a0f8c1f2dfe904544025ef684d37993a25f2d45d8430a9aa88e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6b6628b6dc340fab7bfd5adef9de1000aafdcfe596d9733a5e9af3e649fad6c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "Project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
