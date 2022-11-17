class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.40.2.tar.gz"
  sha256 "b93899520fc944d2a46abf5f310447a4886d059622f867d768e8ddaa3ca0f18b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e98ea4f0645129a6190f232b52004e7de5387e094749a23aa82fb798db581280"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5bad950199c394174f70e6d06875833eb1e87884dd9776d4cdbfc2b739c9eef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdbd7ae0bc4735db35ca1b6f6ea870a1bb365be0cc2b3b8f70c448a77b04bc7e"
    sha256 cellar: :any_skip_relocation, ventura:        "9355353754ffbd31c284883c27bb0641560245d5204d04d9ab91cd1ac878f115"
    sha256 cellar: :any_skip_relocation, monterey:       "e0649a187229d1e01b97cf2e23b8b7070aba297735804811f43a2b6920c6ddef"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffb290101391af14df0690cd94269b31075954d8410ff22b8c5a1dd61ca84eb5"
    sha256 cellar: :any_skip_relocation, catalina:       "23410c5dde2e74f786f170b2866c3616fde7ed51b727dfc5f3090dc6fe103032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6302f1ba7ef604cf0fc6253eeb4f5477f6a63cd046bf5ac77c77bd2ce27ca461"
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
