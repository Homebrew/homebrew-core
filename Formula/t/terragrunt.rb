class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.15.tar.gz"
  sha256 "80e59d4254f06ce8528da0d73e8753d977f90e1a581188d27451a59c94d1a6db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0729011d4e2819435604fa67ec677e1b04e9e9b971b373ee6dbd6d84be905803"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9f54dc3abfaa9aaf218487a025deeebfe47dda6c391dd3ef0fed4cd2fb83c8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e347198ef4a4bfd4b4462e0fd078de987c2573c0a820b29bbd998a6e8bd35da8"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed82722928de7ad33ec42f21fd930ab087f866b1c8c753bbc91299910f0e61a4"
    sha256 cellar: :any_skip_relocation, ventura:        "208a71405e207c420a504c972ca66399607941c8e71623a681cde33fb700ea68"
    sha256 cellar: :any_skip_relocation, monterey:       "4a47e93e3a7618b2f61f951894c7ae256437b9dd321d1de2b84c2434ac768b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eef545d33b0af419aa90f0a50c3bf94685b08ab9db5959d9eb1cd1a46111ae4"
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
