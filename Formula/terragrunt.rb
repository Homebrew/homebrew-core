class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.38.1.tar.gz"
  sha256 "7c8b187a5a516e3e90467960c161c7ef20b105ac9c391ddde27b0cbf98b0ea4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dab0a32cd6a85d011ed2594adc02e492eaa62f957c0fac11d639b17815c0655"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0682bd0bb273e6321ec6dfc15a7dbf7b3e4c8347edc24766114962fd878270dc"
    sha256 cellar: :any_skip_relocation, monterey:       "89400a332d07165fc8df009350edd02af3b5b5d091d03a24bb88f85d29895936"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c64ba8447ed70b64076bdd2802d78b56d5413e133ee41779411ee3b70908d97"
    sha256 cellar: :any_skip_relocation, catalina:       "ef4e094c3ac343a7ebcfab087223cd956f06ee306d7d906d0e39256ff459ed19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80fd5bb0c39d9acd83d2e4e8ac88ecc850d5154f61e2e9104f7ac2c970653a50"
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
