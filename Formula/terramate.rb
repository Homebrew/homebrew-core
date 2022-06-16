class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "6ca667d4483efcb7900d05d08f04e1e20c10e1315746f4f80b04ca5416dddbb2"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f0d7b04a2eca35cf7e10d233a7404d87323b94e1e2d2dea4dbc1d2e221f4f25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2fca0af6487549170aecab7269d0de0cf5f57e126d447a1c547e5ac90b7f5ba"
    sha256 cellar: :any_skip_relocation, monterey:       "9d77521c032f96b13d27a24ef8fdff4fc5fedee8ea9d2a1deea9885faded7a1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b14b9379bf7d3f8b9170469b7f14bf723bf538519184313ea91007ed6a107396"
    sha256 cellar: :any_skip_relocation, catalina:       "fac81de3306c0cf4a9237b833f6e29f1963a9fbaf93d3cf6d0e1a9f3bce85737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56e63afe7cdb9c8923c25259bd0bc965619795905cea72e4029d7037d3a5f817"
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
