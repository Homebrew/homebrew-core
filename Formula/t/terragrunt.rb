class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.68.1.tar.gz"
  sha256 "a19743dde7c66e3ab3753bd48d75b4a2c8bed5a922a5c23bac75a177d4df21ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66915d1a2f42428182ba164e2aef4d0916be207f18caa1d5ebcf0e50a2531e2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66915d1a2f42428182ba164e2aef4d0916be207f18caa1d5ebcf0e50a2531e2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66915d1a2f42428182ba164e2aef4d0916be207f18caa1d5ebcf0e50a2531e2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "40453a897172cae2cce7df4db8d96c4a03114e54bed250fb90721ee216494070"
    sha256 cellar: :any_skip_relocation, ventura:       "40453a897172cae2cce7df4db8d96c4a03114e54bed250fb90721ee216494070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cd27dcd31eacca7f369dea1da7c8b30ebad998ad7bf8fb32fd737a293eb5df6"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
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
