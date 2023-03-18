class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.16.tar.gz"
  sha256 "18cf9eadeba91bee454aa2968cd34df54d2cc9a65d923643391f08257304751d"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e6f487625ab38b0248b061ace496034eca79d929abc8621bf57a663b332b35b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e6f487625ab38b0248b061ace496034eca79d929abc8621bf57a663b332b35b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e6f487625ab38b0248b061ace496034eca79d929abc8621bf57a663b332b35b"
    sha256 cellar: :any_skip_relocation, ventura:        "03af928e75c0db880ee7855357ddaac3baa648f00f2509029c2dde4bba3a9035"
    sha256 cellar: :any_skip_relocation, monterey:       "03af928e75c0db880ee7855357ddaac3baa648f00f2509029c2dde4bba3a9035"
    sha256 cellar: :any_skip_relocation, big_sur:        "03af928e75c0db880ee7855357ddaac3baa648f00f2509029c2dde4bba3a9035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70b6d3367da8278c789f62fc9628c4ff14c33a097c5f0dcc5a2df829a6af2fcf"
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
