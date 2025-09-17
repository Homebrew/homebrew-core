class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "c3e8eaa5ee8b61467da9c69d083dda767ba563d54e237ba3f40970494ee9be87"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90535810c485ddb249857d6f492c1e3ec4b1edb978dda966cd36e7eb0bd714b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90535810c485ddb249857d6f492c1e3ec4b1edb978dda966cd36e7eb0bd714b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90535810c485ddb249857d6f492c1e3ec4b1edb978dda966cd36e7eb0bd714b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8dbbf57b1e5946ac57f6076c4dfcb9183182423aa6b3fc163dcd5e60a7dcec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6a65a455a7f3dbe54c8fc43fb8a0160711783564008dc682abdf851475d4470"
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

    generate_completions_from_executable(bin/"rekor-cli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rekor-cli version")

    url = "https://github.com/sigstore/rekor/releases/download/v#{version}/rekor-cli-darwin-arm64"
    output = shell_output("#{bin}/rekor-cli search --artifact #{url} 2>&1")
    assert_match "Found matching entries (listed by UUID):", output
  end
end
