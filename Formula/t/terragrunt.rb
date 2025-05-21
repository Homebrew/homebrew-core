class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.79.2.tar.gz"
  sha256 "9a4fd3bebe7797d6116704ac9ec5a4128c5810eb5822c5c04a7c1d9880f7b08f"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b991eaae881186b7478e40c35a2e75a3254ff2b44bd87e2802687319423a2d1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b991eaae881186b7478e40c35a2e75a3254ff2b44bd87e2802687319423a2d1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b991eaae881186b7478e40c35a2e75a3254ff2b44bd87e2802687319423a2d1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f25b053ab7f58fb168a43d5dbc8b5b4728eba64c5b0469f1f907b8be91abfa4f"
    sha256 cellar: :any_skip_relocation, ventura:       "f25b053ab7f58fb168a43d5dbc8b5b4728eba64c5b0469f1f907b8be91abfa4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "625c05acc9afbb664cb451289dd63c56602df05e916ab54b660764593adf3742"
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
