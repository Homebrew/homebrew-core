class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.16.tar.gz"
  sha256 "fa24e2b6070e921e84aa0427514735548a3e0e863e0c1c8c7512868063da676d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81851ca27a611acb4115b74541d49c96abb32f3dabea836723ab951e0e30b5a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1677ab811a4b8512a7c9df92175baf1e84619a9353dfb8ea83d508083bd8d9b"
    sha256 cellar: :any_skip_relocation, monterey:       "a30bcbfe74cb4dc5e08918788821731d8f2708467ceeabe377a452c04c76dcb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe1dc684ba0e2222797f7886d80770f96dcbec57c529d0a29c42b5becbf10b45"
    sha256 cellar: :any_skip_relocation, catalina:       "008d0a3bf2e0b1665f6cddb976269d960c7d26aefcd30c54be8c0c68d0c536ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e12c000cad4911967d0f162c4424af10491087ee625494c7658f05b182254aa0"
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
