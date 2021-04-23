class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.29.0.tar.gz"
  sha256 "05e7d5650196ac44af97b081c106569e084bea48956472937d33301ae0c0ba76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "546f94b9f81d94c1a3d87542d72ea9e62d75a842b9d3805f3d6f87681b3eb27e"
    sha256 cellar: :any_skip_relocation, big_sur:       "d0f4cc7233ab9545906a0cd686263ccb8ef8d20242753b41154b6eb54acb0ab0"
    sha256 cellar: :any_skip_relocation, catalina:      "d437a1f1525d38796848a484cc373febbfde12e9e79adb01c71f5b7d7d059470"
    sha256 cellar: :any_skip_relocation, mojave:        "1f925d9fc5714c91e0987fd3ab77f07d21f9b952b37a1e1ab37ad57408d06db0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  def caveats
    <<~EOS
      Terragrunt has been installed as
        #{HOMEBREW_PREFIX}/bin/terragrunt

      Terragrunt requires a version of `terraform` to be in the user's path.

      Teams using terragrunt/terraform need to use the same version of
      terraform. To prevent accidental version changes via `brew upgrade`, we
      recommend using `tfenv` to install and manage `terraform` versions:
        brew install tfenv
        tfenv install <required terraform version>
        tfenv use <required terraform version>

      See: https://github.com/tfutils/tfenv

      Terraform can also be installed directly with homebrew.  This is only
      recommended when NOT working as part of a team (i.e., for solo projects,
      learning, or experimenting):
        brew install terraform
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
