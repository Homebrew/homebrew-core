class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "fdf16f793c9801b0e20a19117afebaa101f247ba35968dccc1eacedbe7a1078a"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5c21cb7cce8fb6fcfb668c68634c5cedfc0e40c52e9b44f5d9eb3528f3d0566"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "655731996004f3ea3273fef3e00d8a740b21dee1649e5337f892a1693ee27144"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da4116f78acf13e09f6e9d1d3eff803d6dae9fbfbf8f2f2458fe6335db12ea8d"
    sha256 cellar: :any_skip_relocation, monterey:       "43cb9c8018ecf1fa60d3ac0c602d7d5bab7f11db07979c6a678de741849ffe43"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba341fe5d5f47404631f94ac8f904f0b79fbd81831ebe782a4f85667bad2e055"
    sha256 cellar: :any_skip_relocation, catalina:       "fac686083e977a8a6102a94916c01f68bfed94a4fa3a531bcd9c7531d76a9257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a2bf73e790c848b860ccb6df45810a5bfc0b6366d31bf60e68d096f46287bb2"
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
