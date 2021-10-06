class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.34.1.tar.gz"
  sha256 "bad7c877cb55d35d4e95c29f9e540b1ee4a85871f6006d3eed53a238ad3cee6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81ee025cf450186c377db940677de05da21b246f3c80d59fa47d0301e6eac404"
    sha256 cellar: :any_skip_relocation, big_sur:       "9894a1e0b2dfa746b21f809c60162af04a5041226a6e7f585aa44f7c62a2c44f"
    sha256 cellar: :any_skip_relocation, catalina:      "4d23af740412e8aeeca82f57379ced0e7098adee2132def06b833531e50e3321"
    sha256 cellar: :any_skip_relocation, mojave:        "f9a58629498c939910c346f728bea33ed301bd7ea7db7781358a6c59c4bf42ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a552b87fe0a2a0fb74bc10276a10fdb052e5d4916528d3c7552af26113c57dd6"
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
