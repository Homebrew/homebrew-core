class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.42.8.tar.gz"
  sha256 "0b6f58dcfe8b505ecedb49babe39d1833bbc68e6759399fb7b9fd932aa8d3dff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a2718246ca2b8ef3501fd4164f12f2561d15f9489ff339d9fd14357f2beba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a272b983d8caad7cca144d2c6dd5d3c43fed179422285455b769e868546d4f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f51aada0e13b6aa516098746126a4fc53859546bbe13cd5fcd4db880ad00ed3"
    sha256 cellar: :any_skip_relocation, ventura:        "0d919dafdb6141d7d51db2ec4c653c9e1c34637cb2126f37d28af20176553a56"
    sha256 cellar: :any_skip_relocation, monterey:       "18677233b446a0dad8aea29d6a609df7548443380cb1e5c460babef4d33fe333"
    sha256 cellar: :any_skip_relocation, big_sur:        "802431c098ee86401aa9d18cf0a29f9e25b372e5f6cf1e4d061b69e8f32736fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80525d3b55cca4b912796583f9baa0084c72482aafebf8bb5104e2967dbeefdc"
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
