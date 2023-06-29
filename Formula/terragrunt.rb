class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.48.0.tar.gz"
  sha256 "e46b550fbf58318fa0faef58cf6b0552025fd473f5789eb59cd479cfeec471f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78ce902fce62c78e998bb43a1f9fe74762a9ad1027961a818a7de039cb7572db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78ce902fce62c78e998bb43a1f9fe74762a9ad1027961a818a7de039cb7572db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78ce902fce62c78e998bb43a1f9fe74762a9ad1027961a818a7de039cb7572db"
    sha256 cellar: :any_skip_relocation, ventura:        "90407f15c251d05aa9a1f80d8bb549512fa4239a79afdfdb67eaa0c347e4caee"
    sha256 cellar: :any_skip_relocation, monterey:       "90407f15c251d05aa9a1f80d8bb549512fa4239a79afdfdb67eaa0c347e4caee"
    sha256 cellar: :any_skip_relocation, big_sur:        "90407f15c251d05aa9a1f80d8bb549512fa4239a79afdfdb67eaa0c347e4caee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9befadcb0c61363eb88262ef0710537ea777e711b004268f48306da9701f8e9c"
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
