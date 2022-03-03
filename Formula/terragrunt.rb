class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.36.3.tar.gz"
  sha256 "3d9c7332d05c1abea4dbbdd14b36698657da8a4f7d2c85c718b032ea5e9e28df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d0aa0e1c0945498884f1aa4bd4dae765d69a5613d2c092ae138e65cc5714106"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "790b10e0ac5ca45012a2f752c3bfed1b16bdf8ae7956729a4cac9c0b9fc67326"
    sha256 cellar: :any_skip_relocation, monterey:       "fbbc381376a481870682d06158643d46ba1df76f959c4c5af319a66b9bfba58d"
    sha256 cellar: :any_skip_relocation, big_sur:        "78eefac57638ca330961731dd821393df9a40cf9d1ae1401af447d4628d521c8"
    sha256 cellar: :any_skip_relocation, catalina:       "99640612fe49c80bef5c7a86c9d8827a8a955eff58bf7508e5f39bbc698eb67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "256b57f6b4cd7cfef71262a6df36217dcc5a97c5c4a930ef2c499074602b8378"
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
