class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "1624472d50b8002a7d97f62b2585d11a79f0ae776b56e7f89dad1d5c663033eb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c50af17f11a3993d02c52b109c9850549a5f911b19ecd88f3678bf2ceccf27e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "668954a5d518d9a15d49b519b411eeea7516f39326647711aa72a3f292d5e7fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41181b2637443b2f8cb038da34eabcab2a9ae31d747ee429aec2a86c51c6d964"
    sha256 cellar: :any_skip_relocation, sonoma:        "994ea8d63ce5455f9202b3a7287ef50ce80fd07873e978e72801dd8ad08d3329"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6642b2a7a704abe1facbae2f54f561b1c686026f6129a1a4195a5a01be1bd2b"
    sha256 cellar: :any,                 x86_64_linux:  "d2a24232656bf41bd107bf5fd83ed1cd2e4c843722ddcb9e6cb6bd4032b65aa0"
  end

  depends_on "go" => :build

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
