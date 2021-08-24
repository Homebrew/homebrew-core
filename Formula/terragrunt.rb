class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.31.7.tar.gz"
  sha256 "3be1183699e58f04ff9bbce1f68cff4d26d927e077089213d6853d076198a55f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e44590345961e23ce1697398cf7ac1633c3d7662178ef2fe4ff0cb5a17d4094"
    sha256 cellar: :any_skip_relocation, big_sur:       "c14385427e83466dcf0e5b4ba9522446f4a06ef6874bc824e373b37aa1faf943"
    sha256 cellar: :any_skip_relocation, catalina:      "71d6e3b857c925a5f254c29c34db04122fd8b0f40d9e48b05839de44943f9157"
    sha256 cellar: :any_skip_relocation, mojave:        "6ad7ec491c2216713554bb4feea46145add088547c14323ee8f67e1be7ab78b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b40134f4d190402d42f157d1e2ff36789f04e26305f25ca4e46b8b72aa23bf8"
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
