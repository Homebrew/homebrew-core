class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.98.0.tar.gz"
  sha256 "beb5e024515c65849ab379948e25e049fb9f0ab4cf3ab21e2cf647b50db96498"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8048cd60db41909ba4f3e7c5b6bc8970a03001bf157b7ac28e776d80661502d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8048cd60db41909ba4f3e7c5b6bc8970a03001bf157b7ac28e776d80661502d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8048cd60db41909ba4f3e7c5b6bc8970a03001bf157b7ac28e776d80661502d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9a3c170af4c23f5fdd52a9870f2aaebce201d4985fc24745aa41c8b7af3eea4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "726ac51c210fe69669ff48fb4a62987673b53a412a83a9a644620c773f342b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e984e9b82ef5897ce273b873974cb4af95d3d3c9fc3d533a059103031a17ec70"
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
