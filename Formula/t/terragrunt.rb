class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.54.12.tar.gz"
  sha256 "d8f1a9d47cdc1402553c02c046891899ae8b9f5c58d8624a9829bf505a94e00c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4a8fa9ee637dd37f95b99f3f7b522228cc4f315ff4a1ced416b6a28e32ab9dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77e20e33a07f1950c78d32b2909703d783672561f2caf05770fe1c113c70f8ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ac4cee9fc4f0f0e1a1e8c8fbb207c0b54ba7cf628456ff6cc202e90f044bc59"
    sha256 cellar: :any_skip_relocation, sonoma:         "adb72c36bcc5b265ea67cba6af8a2d85f7048d2f001e45c1a4e54d9d5935a3b3"
    sha256 cellar: :any_skip_relocation, ventura:        "f69beddfc925d2a501ce4e769a267d3a2e661b284c721327b9aed700a2f66962"
    sha256 cellar: :any_skip_relocation, monterey:       "b7c17a5fb02c03f2caf7c6d8c84316acdfb31eb4a2306a96f2debbb5ede63aae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2f1673d30d962c926ee9e3fe20a8d111c4be47e03e4c5dda0d61ce54781c2fd"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
