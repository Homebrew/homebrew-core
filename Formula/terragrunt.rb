class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.29.8.tar.gz"
  sha256 "4d91c3f8e3cfe0a846095fc24f256a13da0981e533ead2e70804ac55f7ec7093"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a21efa48d7099f3b0da15732d60e1512b919a753cea0676652d339eaa007102a"
    sha256 cellar: :any_skip_relocation, big_sur:       "1329417f75d5a51c6e055769a15710ead2c98dc9066812023de38305ba5ba5b5"
    sha256 cellar: :any_skip_relocation, catalina:      "bd65278a130ad09d3564a80d0607e05a618bb68b9d60dbbcc2f966f6f3fbfe28"
    sha256 cellar: :any_skip_relocation, mojave:        "da7fe6d0f0974f7505185450d00d5ba7df8b4425b903a1f5e0cb228511fa8a2a"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
