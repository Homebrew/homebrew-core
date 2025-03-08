class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.75.3.tar.gz"
  sha256 "9d930a6e67006d2f7dff42037c48e5c2762b166f6390f076dfbe2055aebcf595"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2047a2807b29c9e133a7cba3c8d1da5a1c5ae98845586d97b08694db147ba326"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2047a2807b29c9e133a7cba3c8d1da5a1c5ae98845586d97b08694db147ba326"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2047a2807b29c9e133a7cba3c8d1da5a1c5ae98845586d97b08694db147ba326"
    sha256 cellar: :any_skip_relocation, sonoma:        "97380db82839b7ce72bb3294df23711e5c03de13bec5b892343839296a1dc939"
    sha256 cellar: :any_skip_relocation, ventura:       "97380db82839b7ce72bb3294df23711e5c03de13bec5b892343839296a1dc939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e3c3134839d67c6cde60f76969c94ca2298c644b3b1a782b407418189ea0865"
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
