class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "bc459b43c3da644c827ae15e3675bbf3ed7cb1135f07eff0d98fc8cd6495f2e3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "532d82354b7794e52f7354fcfde7fd2b8cb549f75d0a627889c7a2c61e531263"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "532d82354b7794e52f7354fcfde7fd2b8cb549f75d0a627889c7a2c61e531263"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "532d82354b7794e52f7354fcfde7fd2b8cb549f75d0a627889c7a2c61e531263"
    sha256 cellar: :any_skip_relocation, sonoma:        "667adc6d79d5d83c5ffb9932cb9265cec106221ed4f8049c1f8197f7d3cbe244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "424a916b8f1d7563bb5c95ea586eec52ef3ab7f72b6cdff97f38b65c9392c30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cac58ab9734c2f9f4ed127681ab5651c4dc114696ece2e9fb662ec4ff36ef2d5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=#{tap.user}
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/rekor-cli"

    generate_completions_from_executable(bin/"rekor-cli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rekor-cli version")

    url = "https://github.com/sigstore/rekor/releases/download/v#{version}/rekor-cli-darwin-arm64"
    output = shell_output("#{bin}/rekor-cli search --artifact #{url} 2>&1")
    assert_match "Found matching entries (listed by UUID):", output
  end
end
