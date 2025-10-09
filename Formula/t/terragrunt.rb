class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.89.4.tar.gz"
  sha256 "5557737ad6f924e06c8b180cdcc449ec5c80127a57e62f6c3ddc5d40f79ad344"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6a91ce6980c19c19bfa7bc2544099b3773a9606e2902b5e06dfb445692ad5fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6a91ce6980c19c19bfa7bc2544099b3773a9606e2902b5e06dfb445692ad5fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6a91ce6980c19c19bfa7bc2544099b3773a9606e2902b5e06dfb445692ad5fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3baa00e349d120f511bf622a0e7bd71463b2ca5efef48d3a5381cbd55926c92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "643eca869601b80ded3ad52bc81d0e80d8a79cae16b37af048dbab0186167a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c4a959f0fafbc98f206376f2b343443ee8aa44313ac596d645395fb313383ed"
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
