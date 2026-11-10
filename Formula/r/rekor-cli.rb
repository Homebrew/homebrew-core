class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "9d66a05ed9b4460471e372fe452183c53e40b5c0beef5a685a7b75082d33fa07"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f533367a81e0a1aac27a9965bae0d4e294ab6fcc56c557b0a4e88297161deb6b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f941fb908110abacb851e9f81f3cda9b17f858f53cd7c6fefc887f14b3aa13b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a0e4875c888c60c288d0ccd826841e83630128823b51cb8ae6953a5720483c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b53f9220997c332da8f26043cd6e496d1a1829f8a01fbf6e1600ad6660556b74"
    sha256 cellar: :any,                 x86_64_linux:      "ee466f27d0660763406899c2a978e5df0c1cff5bdbcd99d9c07799101a74b52c"
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
