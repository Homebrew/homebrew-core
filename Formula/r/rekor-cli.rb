class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "84ad7f314c87b1ba8b9198aea318327dfbf97a2367bdebecb0054fb4d8b3b89b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49653b8b8750690c92ff1cd00462638aec874589298fbee806c25e86f010d23e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49653b8b8750690c92ff1cd00462638aec874589298fbee806c25e86f010d23e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49653b8b8750690c92ff1cd00462638aec874589298fbee806c25e86f010d23e"
    sha256 cellar: :any_skip_relocation, sonoma:        "61a8866b7d5853d906201ad1c5cefbd069a6c51a32dd48332829501349975696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6dc6a1eab182b049d9f41f1a1af0ddf727c778ade03edbf8910a404a50817f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69ada55b8cc3141dee6ed1aaa4f1e909257a9dfff08562210db481d503baa1cc"
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
