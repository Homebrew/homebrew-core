class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.52.1.tar.gz"
  sha256 "714826e605a2596d7294883d69018b4c66d80cac9ede0e56d966b56544bc47a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10ee310139fdb9f4220fe2f469131418b3c7d7090af64affb929d83b4cc94cae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46f98545fd1184f5d90deae146b38c66fd224a268e6ef921ec207546330ceedf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24c4a7aeb78fd7d24c87492fb168c643b1c4edc19ffdfdca5683101d2a60f2e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "83bed7a1ca2af0ab8b4c6eb8895a2a80fdf781bb080e211446645574cf0acb77"
    sha256 cellar: :any_skip_relocation, ventura:        "8ede5c6daf2e6b3002a1b95a0ca330eaebc12891daa10140b89e874717832552"
    sha256 cellar: :any_skip_relocation, monterey:       "3030a0be6593ed1d5c7703efac35542d98da2301d7b0b28d9dcd4a2c1a8c6b36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "621cb74a9523d2148f4e7e78cabfe6ab68c0fbfae71d3a5df57d0aa99decc6c0"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
