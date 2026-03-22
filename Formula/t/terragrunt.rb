class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.99.4.tar.gz"
  sha256 "3f04ceecc489812547106383966b113ad5952da1953f11156e2c9b23d115c597"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d751e3ce51140ca8aacf198be7b8de7d93f73b45fd66048720e0a9e34666667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d751e3ce51140ca8aacf198be7b8de7d93f73b45fd66048720e0a9e34666667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d751e3ce51140ca8aacf198be7b8de7d93f73b45fd66048720e0a9e34666667"
    sha256 cellar: :any_skip_relocation, sonoma:        "932ee3d86107a8489d207921fa003ab6af91dee83e3a13aa7a8edc797a3c0609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6ade8497b96b042bac494d3c67380f8a9679d134da60ab477ef0e393b3880ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5c53eb1d17d8702767069534f0107adbc636e577357fb69ec11c9e28cf7fe90"
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
