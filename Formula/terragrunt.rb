class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.29.4.tar.gz"
  sha256 "0d571a995cd7d955612e37a315118812afc8193917fd770014af2f4ff9da840b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "defbea939580e7ea5ebe099a84c59c13ada98e363ff348cc2ae4dd3da02a8d8a"
    sha256 cellar: :any_skip_relocation, big_sur:       "e3486729555748829516df14976bd6a3552e1301144dcf28cb80b2d7d2be5864"
    sha256 cellar: :any_skip_relocation, catalina:      "af2aa449919243abce81809489beaabd23a615cebf90025a9a6fa2909fead04e"
    sha256 cellar: :any_skip_relocation, mojave:        "d9756ccc69a6fa769a4e304707599fc3e2629469a4a5f300af267924dbedfd2b"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
