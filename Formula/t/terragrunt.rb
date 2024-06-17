class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.59.3.tar.gz"
  sha256 "188787433a5de982ceaeb20643bb390232c67604c7302d8724c7fba71bc15a94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b955b8846343415bcc6231108a475b38df5cab7117a99586f569a6558909b7e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e8ab5f41510bd2d4c3fe2ab3545f05a8acbda2a3107c156df6929889c27bc48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f806134b6bfa9c178223cb9937895045db0d95841b2449acb106412c3b924a95"
    sha256 cellar: :any_skip_relocation, sonoma:         "e99b8cbd3644c2fd0359bc8b0834d1b342ec01f1650be2a1a4ef49cf0ff4880c"
    sha256 cellar: :any_skip_relocation, ventura:        "edcd764d83c2d0f1be0dcea1f701ec72bd115bcb9327b9b7d045f024c0797bca"
    sha256 cellar: :any_skip_relocation, monterey:       "abd6a3513222a77a18cb41d450e18d584058e212fb0fc211e814996ce2c91b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcf75327ad3f36fab799f12245b7d0869be9751fb397639a5a5ec339500dff5a"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
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
