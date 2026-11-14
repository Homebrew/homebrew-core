class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "deb15da4a3e05d090656c35a520fe5dfb63976c13bdffa4263f48ce98cac84d6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5789bea22adafea9bfe4c1c305eed319af532586c13e6c55bfbcc584e15ce28a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "865601bcabd08a26cdc9008a5f2e26e9350a46c2dee2160097644c02caf51c28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f63b65ba7effd273bd66f0fd785c759990a9565b933db583badabc8e9da27d61"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ed23ed9a2822b9b7d0d12cd91bbfd644d79e27f201f0c0ee8d3b1dc7cb312092"
    sha256 cellar: :any,                 x86_64_linux:      "5710f716436987ade13c060c9966337b8071b515d6b8c07c828183292686e2ea"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
