class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "fdf16f793c9801b0e20a19117afebaa101f247ba35968dccc1eacedbe7a1078a"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e318ccdb5a5e4ed0f8699bd9225d6a379af63dfae7fc218444a8a47eded77648"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37d6313c56cb66044e8dc249f523343e85816940356d8b1e34df978bd42a42eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "814c764e5c8ed4457d1449a8053994599d177688054350e8edf657419de63fc7"
    sha256 cellar: :any_skip_relocation, monterey:       "5b3ac4bcf5ed4568a50872a3c5e59d5f6d069aa1a065b635cf499a9e9915b44d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a6855af1d6bd510062074ed8858c84c00742b18f4b97790481ce7055d5505f9"
    sha256 cellar: :any_skip_relocation, catalina:       "69c6af6ec43d25437b5786df8a80be4a06c0b281c8b3afd36fc5dd0abd0ac72a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "043a4f0902d80a4f6b72567fbd46397d475c9f869f2b604a4827816ece95230e"
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
