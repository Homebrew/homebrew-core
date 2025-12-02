class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "bc459b43c3da644c827ae15e3675bbf3ed7cb1135f07eff0d98fc8cd6495f2e3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3f442dd21a8bcb916557c19626d062d224a2528dbb8f2f407fd64f42f745b1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3f442dd21a8bcb916557c19626d062d224a2528dbb8f2f407fd64f42f745b1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3f442dd21a8bcb916557c19626d062d224a2528dbb8f2f407fd64f42f745b1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eb776133c680c11283830a9c8db98d4d019987e11ae6d6e902a3f0e97be9784"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "579c88b107ef00034cf9f495c648e54397efb045346975bbc090b86ef971d0ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "835024c0d2f5e990e4d24edce5d67b6df4c11254bf8fa9cc397378144676c016"
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
