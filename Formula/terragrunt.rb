class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.32.1.tar.gz"
  sha256 "356336dc500a4b0b7529aacd024426cd15ef27641ce591722c0052a80a9035b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c60c490e9bc040a342e95146e68e4bc001bdc2bb83ada2ef078eafcb47fe5287"
    sha256 cellar: :any_skip_relocation, big_sur:       "ecb994f4c5207e788dc550d98a8776e0db67f435e1e65e08359091c690142546"
    sha256 cellar: :any_skip_relocation, catalina:      "5529809ac6ead82ba14077a7b1049f11847464b4ba1679b3daec620a48328a94"
    sha256 cellar: :any_skip_relocation, mojave:        "0bd1723087cd2a662d3aced1f94faec58cd00eec7a58a13d805fbdb1065d4f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c59de90c85a1c103d2468613453e5098f58822c2bbefd19a5907a42752fe3594"
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
