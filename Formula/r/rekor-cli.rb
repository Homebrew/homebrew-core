class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "a2a3addc454ddc07c1a5d43d104377c2928b0c9b2415a5db7b4fa1b9fd16c7ad"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "d4f3c19c0509c070a32b8090200ee44229b035013b7b84f9f9f8f3ad708544b1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4643992102c0ab350d715507b3b17b62d60a9bdeb64ad229f145ac0e46ecc691"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d3c37cd03b21094601f3b7d17b6e046f071e995aa6716f49daad27502c45902e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "51a95bb3f51e9a9de8dffef532b547d7e1f235057b865f1bc94b47cf5575b2e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bcce1786fa1534b4233fae43f95402133b123d016933eb22353b10c3e13c3b2c"
    sha256 cellar: :any,                 x86_64_linux:      "b3195459ce221f992efa5747fb9ba7d73d746de07aad9a8953ad205166aeb706"
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
