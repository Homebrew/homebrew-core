class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "b42e4157f24664746cf9dbbca00f2dcf7260383218e15d5723c8174ae3280c42"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "677f70eb75ccb7eb9bfa892aa323d6a1e2b5269f237dd201931a06c75dc4251b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bee22877f9b439ae8be26dfde05851a3ce667fd2542cee7eaa679179f5da8ca9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "718fd6be9366845bf93b75dc6242691161be6c9fa1c9250646f50f23f9bc1ae2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0417b6eb42ba18f34cec3e674ebf6e10720bbd4a16c83b664888a3a831ae4b74"
    sha256 cellar: :any,                 x86_64_linux:      "7b5eb468346b3a8389761548bbe5e920d8f49a55d18cae2e204bff5927aa031c"
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
