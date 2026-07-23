class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "221ee7c56af34d92bcd18754f918fc5533f2b7c5a2ff3f642f659e00fb1be1f5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97e6dc9fb0eea3e0ac3b2f7912858f054d7d5e5e1cea85f96a11a2f29449a51a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97e6dc9fb0eea3e0ac3b2f7912858f054d7d5e5e1cea85f96a11a2f29449a51a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97e6dc9fb0eea3e0ac3b2f7912858f054d7d5e5e1cea85f96a11a2f29449a51a"
    sha256 cellar: :any_skip_relocation, sonoma:        "71bbf3398a4fbbc3dffd47ba059c462cae7179fe58e3a1d7b29050df8174c90a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "934a7cbf9801ce8a7a9cae672d8384bfb36816cd096c389782f32d4dd0f4d5bc"
    sha256 cellar: :any,                 x86_64_linux:  "f2192204d7837843c69e70690e59ae2d7c903bff3f3ec8c2a53e691f502e8c01"
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
