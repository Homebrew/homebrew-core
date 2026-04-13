class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "3b6e0c202ed4e387a095852e680b6503d46d7a26ce8060daf223fe6657450983"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3015d97b694bd2a14db852c57c9d53a029e77f29b45125d906d3d9fb3715c58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3015d97b694bd2a14db852c57c9d53a029e77f29b45125d906d3d9fb3715c58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3015d97b694bd2a14db852c57c9d53a029e77f29b45125d906d3d9fb3715c58"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f356be3d43bf51680eaa4aeb76b6ecffd90b0c3db969dd1260c1a7420c9a0b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69b766112dae48f1c329b5550617a7192e2e0514aa752c8818d14c69e981fb29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3767a5534fe576d29b472e5b59053b3d833e3dd400fc6bf72bffe5b5a0a0941"
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
