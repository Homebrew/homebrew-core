class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.77.22.tar.gz"
  sha256 "a506d8d05d6eebf757b0c1c3c18c70ba665e465b4088d4b176e48f14b892fc0d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c70edc0aa60f06cd6db896628791f8f069354ad1bbcdc02fceb803a97908b05a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c70edc0aa60f06cd6db896628791f8f069354ad1bbcdc02fceb803a97908b05a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c70edc0aa60f06cd6db896628791f8f069354ad1bbcdc02fceb803a97908b05a"
    sha256 cellar: :any_skip_relocation, sonoma:        "647dbe59f2f46de16a3dca27ab153a73604c37faa4f5012efe2be0f45d3853d2"
    sha256 cellar: :any_skip_relocation, ventura:       "647dbe59f2f46de16a3dca27ab153a73604c37faa4f5012efe2be0f45d3853d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae7e50f9c14673db9508a55051fdc182ae44aaef5f10e67da00464c6cc52d73"
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
