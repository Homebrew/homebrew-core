class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "20d51b5a616788a3740dc86e47ba606c90a39f1fafe64f81715e7aa595ddd352"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd9d7f1fb8ff3564d05cb5e963adaed116383cc11e9adb0c9b7baae853d4cfbb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "169f401d795ceb7b0febc074b3c27a85f1fd46d398f04afd6e4963885abb71c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64a400bacc55bc29329df930a5d6b230ff2ac77dab33987a7b0afca76fc98f87"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f040142c81a10c6a140bce251eb516c5741e863df7c72b76f5e80c354c1e35a"
    sha256 cellar: :any,                 x86_64_linux:      "ab81dcec6aa6b04f5589361984ac1a7d8af4ec3eb3e962ca7966a6e508a468ab"
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
