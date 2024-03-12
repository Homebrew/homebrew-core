class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.14.tar.gz"
  sha256 "96da6879657523c0ced5803b248f4619c0e2e5c67e5b6988d7fa062525593e1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bd3049a85252e5db67a4ba2c855a40ac8865d872a8d0564cb386d12c11c98e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d641ee8c564e39d28d2782fa84b276cf4c9fca8bcd652bf270fe999661e5c29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7fc51f752048788165706f1fcf3f53607eb39bdd61ad923803ad06e9c7ed6f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c6c64ad9186cf65068a0aef87b4579fbc74ed29d0db4e95390edeb86f5444f2"
    sha256 cellar: :any_skip_relocation, ventura:        "4a1271e5664d4c78fd8d6a1bbbeda60884e3d80105afe246cbbafdd4a63c33c5"
    sha256 cellar: :any_skip_relocation, monterey:       "bed5d491cb3be7e12ad7742165875adecc8c7cc6acd4f08f4bf5788f0fe86515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75d4b78787c27c2c722dd601e410996c58b9af7d5fede8a5134145cfd08675f3"
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
