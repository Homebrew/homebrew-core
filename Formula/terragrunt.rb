class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.45.4.tar.gz"
  sha256 "0a29dc0a60701fecf18b067e466787f93ee4e0160d3421377446d996cd235d68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9363489b6baf852203489b73e9b80af562aff9276888816ac9701fae17c64b2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9363489b6baf852203489b73e9b80af562aff9276888816ac9701fae17c64b2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9363489b6baf852203489b73e9b80af562aff9276888816ac9701fae17c64b2f"
    sha256 cellar: :any_skip_relocation, ventura:        "deefa855c786f642cc1e6ee9b8305510f2e1e0a683a4b201a272ef8b0a68bed6"
    sha256 cellar: :any_skip_relocation, monterey:       "deefa855c786f642cc1e6ee9b8305510f2e1e0a683a4b201a272ef8b0a68bed6"
    sha256 cellar: :any_skip_relocation, big_sur:        "deefa855c786f642cc1e6ee9b8305510f2e1e0a683a4b201a272ef8b0a68bed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4caaf2e28df8b50ffc5ddee61299826366a86ef6d72c85f936cf6d26362d79ca"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
