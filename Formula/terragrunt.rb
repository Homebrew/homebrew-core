class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.36.9.tar.gz"
  sha256 "657f77d56a26a5a987e956e841c47d89e1b1691db2e40d3e263af1300af203f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70b6aa66c21d14bf8d292743e0d08854bfa08d27cdb831677562a9d2093a30b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "300989e56e44a722d2f28b725bc56af86d880c3da9eeace29814721a73de9bdb"
    sha256 cellar: :any_skip_relocation, monterey:       "39bee4cab7a67fe455b4da62c2b821003a9e705eaf0e81b237c5b8194194b1ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ac3ea7c1c7887ed9b720621e93c1d599b434165e42368e8267cee3776a53a0a"
    sha256 cellar: :any_skip_relocation, catalina:       "bd1eb81576a3afaa56b9ec1a4abb53f565c45927f467105945db26bdf2c09d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c7923769e399c1ecf0365dec8cd44115f4eb7d280e9b82e90525f61ed82ce1a"
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
