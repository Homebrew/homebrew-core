class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.47.0.tar.gz"
  sha256 "ddc0171d1be0f603b4c2fe8cf51b4a2084477f4c0ebc13499d6ce92c492bce6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9179361e31a7b042e59211f4fb4625fb0c6b51324cc3631e06e2a36b7bba4a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9179361e31a7b042e59211f4fb4625fb0c6b51324cc3631e06e2a36b7bba4a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9179361e31a7b042e59211f4fb4625fb0c6b51324cc3631e06e2a36b7bba4a8"
    sha256 cellar: :any_skip_relocation, ventura:        "b90834d31183b46e2fe0f535f29755875d4c224ca2c9b52d83cfaa61edab8953"
    sha256 cellar: :any_skip_relocation, monterey:       "b90834d31183b46e2fe0f535f29755875d4c224ca2c9b52d83cfaa61edab8953"
    sha256 cellar: :any_skip_relocation, big_sur:        "b90834d31183b46e2fe0f535f29755875d4c224ca2c9b52d83cfaa61edab8953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06435e1c3a0edd0c98ee671854bd86636943a9633d60275489051b77901049b2"
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
