class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.46.3.tar.gz"
  sha256 "7ccb057317d5c7073a3c510ab9670cdb429dde87e5c6b18597a3118a6b0107dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ecefd701ba19ab00f6fcd7e2866ff915dcb714ade04332847872f39f20e6f7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ecefd701ba19ab00f6fcd7e2866ff915dcb714ade04332847872f39f20e6f7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ecefd701ba19ab00f6fcd7e2866ff915dcb714ade04332847872f39f20e6f7a"
    sha256 cellar: :any_skip_relocation, ventura:        "ad7ced6bf91811347c612d17cbb3dcc48ada805f4210ff16420ea920446c6d53"
    sha256 cellar: :any_skip_relocation, monterey:       "ad7ced6bf91811347c612d17cbb3dcc48ada805f4210ff16420ea920446c6d53"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad7ced6bf91811347c612d17cbb3dcc48ada805f4210ff16420ea920446c6d53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69800f4fb8d5482a6ba6bbe1693bc14923970b10621e50b5621a784d217f4251"
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
