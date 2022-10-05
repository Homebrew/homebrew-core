class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.39.1.tar.gz"
  sha256 "f4921b3f4e7b73420e293a36c7d1417896a397bbad593f07bae666110ccca02e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3b00ef24bac5eaba577a6ea2636e89cfffd3327cbb0ef592c6472a4de511ac2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f70aed7003e1287b0969028893014b85b2e2a45b65b29dcd9b8f8bc071e9cff"
    sha256 cellar: :any_skip_relocation, monterey:       "5f6836e21ddeb19327e52c0e7cd5261e49b5957aeff7253f5c5a12e8d856ff9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fea4451dcb695232e52bd1b6a6536164e66fa6df1202dfc04b6f6eeaf8c66b7"
    sha256 cellar: :any_skip_relocation, catalina:       "f2363a715046e50ed21a966bee692e30a011e9f8bcf11bf2990b335dfaf97f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a51a24421961a66bf62fddd317d3b0c44e18225d4a719fa182c4358078c704da"
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
