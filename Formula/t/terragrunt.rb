class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.78.1.tar.gz"
  sha256 "58cf4815bf38b287b6273fdbe0e261a4cbebbe92ebf3d22222658a1977751ca8"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d96d26478352f055b2586f918f9c1bc8b133a9a22f049bd827b6deb6e2b9e5c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d96d26478352f055b2586f918f9c1bc8b133a9a22f049bd827b6deb6e2b9e5c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d96d26478352f055b2586f918f9c1bc8b133a9a22f049bd827b6deb6e2b9e5c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "16e30ca5eb2782cd74fc3abc3b19b088e0731075c9752cfa22ade2cc2cd74ccf"
    sha256 cellar: :any_skip_relocation, ventura:       "16e30ca5eb2782cd74fc3abc3b19b088e0731075c9752cfa22ade2cc2cd74ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbf0d78c43e00ad99e763f317daf5611efc980f14ff349f3872c001815fff78d"
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
