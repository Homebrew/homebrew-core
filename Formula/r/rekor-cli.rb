class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "18321f5ae1c394ca6e888fffad7d67d31170bcbada77b819898312ccbda64fd5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4454d55e8cb20f49ed258f12fa2e087e89a87c013318a6e8fb168bbb16757468"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0a5e5c942e8cc13c1229a39ddb5c8dc5ea8a8aaab3b340e4e88f2546598678f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a68ef90a39bd55ea65d5e80e2be16317d6c8dd6a92969a64875c293df098795d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "25334376bac3fa6a1071ae8c01c3dd9968a5ccd26e959366ab21297321fdbfde"
    sha256 cellar: :any,                 x86_64_linux:      "e813f1206603a02fd2703cc17ac9dd14f1c370dceb32458d9b3a661785c67277"
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
