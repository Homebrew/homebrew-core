class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.38.5.tar.gz"
  sha256 "15c385c11cb0048a8e7d07589dfefceff887414f1ffc5fa2b6853132f211e93f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "613096f698d929c2e975c0c168fb1c24e460f1e81753f7b3d42b07aa11779820"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76c8bf27d7fd4210bb2bfae85d268310802c2394c0be027dce36c61fc0ee9caf"
    sha256 cellar: :any_skip_relocation, monterey:       "89efd02e5ab73163865d4d7d2b95a7ada41050bdc6d803eee2ee0fa814703c27"
    sha256 cellar: :any_skip_relocation, big_sur:        "29c902d1d78267b234dca42864dbab8e3133f3acf6a822e6f5f9a0bda885e98e"
    sha256 cellar: :any_skip_relocation, catalina:       "90b7e9a6cf05dda5d106e7c31a2c8f48495720cb765deab0d1674e5b94cf1c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a87a09444c35cd7fbb8a616a27e7c64c6c45a34edd0a7eeb4811fb347980061"
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
