class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.88.1.tar.gz"
  sha256 "f47db272bce451160fbd524f0645020b0faf66849084cf3531800474f36098dd"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3258e7d06d30cf4233bcaebc912e9e92aaa74057b703a4d8aa31d79d577206f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3258e7d06d30cf4233bcaebc912e9e92aaa74057b703a4d8aa31d79d577206f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3258e7d06d30cf4233bcaebc912e9e92aaa74057b703a4d8aa31d79d577206f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "442209534ca84cbc4f3fbe5406a4c6bb67f0080306fe2a6dbbc15ce655104a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9914041f07218642ee31a3dd48cc31b6344e1ec2ecb36189dcffbf058857390"
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
