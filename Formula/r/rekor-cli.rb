class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.3.8.tar.gz"
  sha256 "1bfdb9167624cf0125a9e7852fc3eb406b435d8e3949d91fcc47bc1dc7501009"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf85fad86d46685a2580923c31e24fff6afbde2b86e749f40dcebeb5e92b51b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf85fad86d46685a2580923c31e24fff6afbde2b86e749f40dcebeb5e92b51b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf85fad86d46685a2580923c31e24fff6afbde2b86e749f40dcebeb5e92b51b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bee690b307cdb4f4978f4b0180f8e2100f5c89a986cf087d50472e54d7358aa6"
    sha256 cellar: :any_skip_relocation, ventura:       "bee690b307cdb4f4978f4b0180f8e2100f5c89a986cf087d50472e54d7358aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c67508549e09925a0393677f4603119403dd33d7d771182c6bfbef5c1c76ab04"
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
