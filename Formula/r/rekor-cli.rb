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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2a2d70806f20609ee4d523317bb1fb302959c96ce96c87ddfb3b77ebb092349"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "931c06a8ba9fe93c0b14d4e587e5abdd7d608f841a3808ce124f7ce389ddb18e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4efadcefa6aeba68c483eb7039843c00913c4f21eb7bcd17817ee04dd943c250"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "967a089a3d709e205030b5ac728436b0471e2d21b3fd2ca3e5d8e2f9457e632c"
    sha256 cellar: :any,                 x86_64_linux:      "bf32ac9a349280fc46815e38d21f9730d74d296337c81c61e83edd47a267cad2"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
