class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.78.3.tar.gz"
  sha256 "dc8c21e17e7014e4e6afdd40279284654bc241a741c7528c03c32d80e0a94c84"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79ae2cf4af092b7a2b09d97165f8e2b23d36de3d67b1925fbd0dd5f286a044be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79ae2cf4af092b7a2b09d97165f8e2b23d36de3d67b1925fbd0dd5f286a044be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79ae2cf4af092b7a2b09d97165f8e2b23d36de3d67b1925fbd0dd5f286a044be"
    sha256 cellar: :any_skip_relocation, sonoma:        "458f36c53b5d090c5454c26fb6280cd95228a2eef5aece03956f1efd0520e3a8"
    sha256 cellar: :any_skip_relocation, ventura:       "458f36c53b5d090c5454c26fb6280cd95228a2eef5aece03956f1efd0520e3a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "579fb2160c68455262a0b76ac78dd49b1337f209cad201edbfca2bd1c88340cd"
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
