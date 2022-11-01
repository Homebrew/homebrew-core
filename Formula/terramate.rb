class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.40.tar.gz"
  sha256 "9e6d7582da1ba11c67adc2a04eb9ac91824fa61c3486bbd0aec25b23c4cd61a2"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2d393ae8ac01d7ca8ecf08492586705db2d9ec7dca71c686e1ec446a7e4e4e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52c4298da9af9a3ca49901f71660aceee2a9146c98b361df5635bd685f02ddb2"
    sha256 cellar: :any_skip_relocation, monterey:       "b0108f2c5c67c64f8ed338b0e82484c75218c0e802921a0835fc14ac083975c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d01cbcd217bb1d0fc89b37f70aa2653ff5d62d7cdbbf248e6bfe358978d1f7cd"
    sha256 cellar: :any_skip_relocation, catalina:       "a642660b200ca3c49d4e085a01d1bc066837b676715cd64546d1c41a84c73aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2783507486f328203e66b5f438fdd440c3a623ad57b10b2d08ebe7ff5e26fc05"
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
