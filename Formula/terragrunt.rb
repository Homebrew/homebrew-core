class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.42.5.tar.gz"
  sha256 "f8526bc6c0daceb081c3f16bf0d83411aa070b65c25ff124b4ce5cc397ec6080"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47d8774884b4f7ffa55b218278adb0daa5358ce31ff426c29816671fa15cec3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5008c14a4b9b4db365e570e34c0c7b492c9b2f33ea22837d8dfa31b9ac846c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c43f0b9631b09bbef381db804f28bb6a9f7a77edf3c4f37d202e8c2b38292f3f"
    sha256 cellar: :any_skip_relocation, ventura:        "6bc522d9b01fe9ebef49aea9e05703918ec543d8933b49091a91477720fdc51e"
    sha256 cellar: :any_skip_relocation, monterey:       "3992622fff9ff89dc8c2556bf582f8c36a31d7908e4b607f2d9127bab742c317"
    sha256 cellar: :any_skip_relocation, big_sur:        "b31bffcc074844732abbbfe3e0e67457f385246e43a42ca3d2b3d10c32098a13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f2dad466ec765a7f8ed62216aad1883b6276199e45de86394919569963ae20f"
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
