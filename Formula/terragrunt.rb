class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.31.1.tar.gz"
  sha256 "127490a12f542089adcc4e8a609eae5042d25b25b1271405132189253fc73685"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4d066c3cbfed15778e734eae7fcce07297eeee1467da4198f9e46ee0ccfb166c"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b8dc70aa56b19ceefe0a6769f14607b7d905d2d85921284a42745a7c7fdc550"
    sha256 cellar: :any_skip_relocation, catalina:      "7b5b37c16d92f8f7a47ccb64350ed13c43d4aeaeae70f3724a032402898b4f11"
    sha256 cellar: :any_skip_relocation, mojave:        "210453c49031412cfe2b3030f84195fedb926376f5dd5bd91cf8b7d7779decda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ca4167493072e30ee31fa0135e8e8a3afecfdbc779615a0531196611136077"
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
