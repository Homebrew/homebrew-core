class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.3.10.tar.gz"
  sha256 "28967aa7b3168b745f03547dd48b4be4d99b74df5a034942227a87067de29995"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72adeb8aff63987e2fe31c48b8dc0c193264aa6c85f6524163825a8f3ae494bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72adeb8aff63987e2fe31c48b8dc0c193264aa6c85f6524163825a8f3ae494bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72adeb8aff63987e2fe31c48b8dc0c193264aa6c85f6524163825a8f3ae494bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d333f5e92d551acbbab84c88d69211644b89df5303c36457cc298849c5bbb807"
    sha256 cellar: :any_skip_relocation, ventura:       "d333f5e92d551acbbab84c88d69211644b89df5303c36457cc298849c5bbb807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5055688e7d183eb84d4a9bc1653e7a7180bd01dd8a9df2cd76db2072047f4fa3"
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
