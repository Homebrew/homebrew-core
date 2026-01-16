class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.97.2.tar.gz"
  sha256 "28894180a9fdd864abfd0acffc74f5a53ae6956e7b03742cf526dfd9348737d2"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e5a27f8fc255c607277e7765eed16acf3adaf90b3eb62083dc4950fbafbbcb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e5a27f8fc255c607277e7765eed16acf3adaf90b3eb62083dc4950fbafbbcb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e5a27f8fc255c607277e7765eed16acf3adaf90b3eb62083dc4950fbafbbcb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "635ad510f3ae60c5d29adcb6d9fb3d482e69d73e379680f2b4cc64e082409aa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "441f176427969d80e67a211bd4df2b4a50e31474e80fab7dce49468f71e9e15c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39201d839a3e2d3db3c357c0fb9192c8181c24ee910bcbc03c788b721daffdb0"
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
