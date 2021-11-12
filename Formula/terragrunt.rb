class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.10.tar.gz"
  sha256 "40100e6e9a3eae36c35c36dfc98a8adc5a8ea72bc5ffd1b1833eeca56c7508de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5006812b4b8f47268b16126ccd0f8541dd9969a28dad443d4d09bf2eb4c386eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a323c2935a98b59e139bb9c68de45ce759803b5ee957f0d8497f326a2e3d687"
    sha256 cellar: :any_skip_relocation, monterey:       "680eda8faf3c2b8921c868ee0a1c5178b3cf18e212ac8b8b6dcebd318a78234c"
    sha256 cellar: :any_skip_relocation, big_sur:        "07632670ac340e35a115d4aaf974e418034f4efc3e49382b4b2877b16cc42465"
    sha256 cellar: :any_skip_relocation, catalina:       "86ecfa2674875fac892de96f29bef4f06b1096d513c948a0c0c6f10ae8fb1ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "082c2c59013d54105d803633c4a264bd236b863876687c2c47cabcff5daddec2"
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
