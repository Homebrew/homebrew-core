class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.3.9.tar.gz"
  sha256 "196411c9ef88769ab3147c99b94947810e2f40eed0f2fe00b14fd33e8ef1b221"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16f2ad8841be9c2d9978177e593dd888b955267a38207f1ce2a7e52d86825321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16f2ad8841be9c2d9978177e593dd888b955267a38207f1ce2a7e52d86825321"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16f2ad8841be9c2d9978177e593dd888b955267a38207f1ce2a7e52d86825321"
    sha256 cellar: :any_skip_relocation, sonoma:        "4398d5d86fdb647e8082e3bc72c4a46f1ffc38feed6d23ba017538ff219da4a6"
    sha256 cellar: :any_skip_relocation, ventura:       "4398d5d86fdb647e8082e3bc72c4a46f1ffc38feed6d23ba017538ff219da4a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a942228bd937e08cc139999d5c7ff174a5d984a45902066aedcf6dda4404173"
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
