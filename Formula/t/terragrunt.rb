class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.17.tar.gz"
  sha256 "cb373ead19f9a39d27a62f63ce89b61fc9547dc665496caed5d81a901f1de1b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9683cc851b168999d58d25cfa24af2d658ced9811b29965db05aabdf947826c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f6acdca98c097945b09b87e5f403e86c68984f730c78e0cbec993e389b3222c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b287485225f3c771362bdd0837b04652770754d22858900cd6e8bb46f53cb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "e43f4da51e5712f4a21e0a0e92d5bf7c1709290b334da371a0cffcee3bee6d6c"
    sha256 cellar: :any_skip_relocation, ventura:        "454e76fb035b71bf1bf90a613a47fc3d9eab8fe1f1fdb001f3d0c74c39bfc25e"
    sha256 cellar: :any_skip_relocation, monterey:       "301656ac072183f1f730e3f3ea9e8090dc795f9da4d0a930908e39de580ec64b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "043389d4a4a859f17212b0d5a1339f23fd3854a8540ebf7a0e4db97f960185ff"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
