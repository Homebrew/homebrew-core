class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "1a63430a252e680b1dbd11ccc7d5ed0c64fc3b9f0ceef9dde3b39e210ad8e742"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7055ff35eb8c44d4b8a805a726c28d172c926f60c27d95c95530a58c48e17812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7055ff35eb8c44d4b8a805a726c28d172c926f60c27d95c95530a58c48e17812"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7055ff35eb8c44d4b8a805a726c28d172c926f60c27d95c95530a58c48e17812"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9f3875f760e43640bcd8da6e3c2fdff53e89ed83e5cd3d2c9bb6de6fe07518f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67ca5a974f33862b29c9cb18f0201d48caacca6a1db4fcbc0725a3ead47b1b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aceaa27243fe91fece46e9288ffe74c0cabd6c394cd0fda63e706cc0931fd340"
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
