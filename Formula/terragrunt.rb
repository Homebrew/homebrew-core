class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.45.10.tar.gz"
  sha256 "852247eb5cc6cf81ce92ca73ab4dd3013efd11b4c7e24b6a29ed6eb740bb9772"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c4ae034d75c49a9b79cef18378e5e21e318fc96005027e057688ce7fc8234f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c4ae034d75c49a9b79cef18378e5e21e318fc96005027e057688ce7fc8234f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c4ae034d75c49a9b79cef18378e5e21e318fc96005027e057688ce7fc8234f8"
    sha256 cellar: :any_skip_relocation, ventura:        "ea379df199f8d931ad9b1989f27612cd255761e03cf5301cb9ecd35569eb8b31"
    sha256 cellar: :any_skip_relocation, monterey:       "ea379df199f8d931ad9b1989f27612cd255761e03cf5301cb9ecd35569eb8b31"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea379df199f8d931ad9b1989f27612cd255761e03cf5301cb9ecd35569eb8b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c713217c9cb44728f2760f1268534689b53f746c7fe66de404dc222b0b94c973"
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
