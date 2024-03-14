class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.15.tar.gz"
  sha256 "80e59d4254f06ce8528da0d73e8753d977f90e1a581188d27451a59c94d1a6db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c25512bed01c541bec9985cfd23fea2e15005631ed9f561447ba751de0815124"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc20d4162d480a20e07379d88aef8d3011f48b8d178f81262c87b4a4f12cdd7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64b44f00b859a315691bf518e18b97c542a5cc713553b21744da08632275f1d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b644ec1d61d2777b4f7bc7b6342116a01fa79a7e0a7959fcc5ab9d373ccc32c"
    sha256 cellar: :any_skip_relocation, ventura:        "35b07606362ec432828a2d167e5d4297d9f4011f3ed223269d9ce05bc26d1810"
    sha256 cellar: :any_skip_relocation, monterey:       "d270387f09079dbbff3097194d7d824bf6da54d7cd0555609a6574b57f373584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bef0ef245611a415eed3b63b1c590ef7a61199a665134f583fd729df7da72a7"
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
