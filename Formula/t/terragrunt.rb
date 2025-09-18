class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.87.4.tar.gz"
  sha256 "7013e638fd047d2aae8fa3a64b563639122ad2d691df923185db5bb165ceb2fa"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41bbb636551bc988b1cae98e512a4960aa2025bd5529c80522616433e42d8df1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41bbb636551bc988b1cae98e512a4960aa2025bd5529c80522616433e42d8df1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41bbb636551bc988b1cae98e512a4960aa2025bd5529c80522616433e42d8df1"
    sha256 cellar: :any_skip_relocation, sonoma:        "93be4d974f9ace8c71aa99f373e88049be924c66df2834f4267012dd51e445d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "939bad760302aa3cf2cc3f214b37f0e9dff579f1affb6215c5751b9648e76f81"
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
