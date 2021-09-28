class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.33.0.tar.gz"
  sha256 "b8cd1571a6e31c61178a32a1e6ca97f2b1f3bf58637445eb90ffb16376e806c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8b1b5ff8eb9f16368bc7fe4547cd3c51d464a6e5d3c9e8012f7cf564f3efee03"
    sha256 cellar: :any_skip_relocation, big_sur:       "02dffeb12774d3d906134ce728a8b48d9e741999f192f8e6590328b1e60c2be4"
    sha256 cellar: :any_skip_relocation, catalina:      "b19b89dd4b4459987a7f0bbcfba808834210838b15be570ff34f4154e7882aa3"
    sha256 cellar: :any_skip_relocation, mojave:        "c2bdfc3ecb46323b3da79cd55897658d033b3836a4bf84b0ebb0f6f785a305fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "431d7be05fd1ffdccf78baa5c8a190cf0913a6b1cde3558ac648f1b115e01d0a"
  end

  depends_on "go" => :build
  depends_on "terraform"

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
