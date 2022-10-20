class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.36.tar.gz"
  sha256 "11a7eb194a270dbee8ff4d3fc4a5926aeae685bf656d971a86ded93d6392568a"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "140ab579b58b355dc64c472d60bd306e588ac25179b4ec151024eb4bf78c51a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8a8e6eb2d1a9042542dfed7f8e43ba39b9aef1656688e975354e752854860ad"
    sha256 cellar: :any_skip_relocation, monterey:       "683b6e86e0b3385cdf125cb9abb3a002bc501859700df7dccb9c42880aefee1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f7e68427e3d4c76e3b0b675c8172c8b1652d8cef105d265cce205876c3ca2ee"
    sha256 cellar: :any_skip_relocation, catalina:       "68469e5def7ff2cad2de2073416121ba7795e6a5d5496a382a085d2da22a039d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efd938d4a928c8b7002b38293035d25dcb118b0bd888a1f68a131a4ff3fa10e0"
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
