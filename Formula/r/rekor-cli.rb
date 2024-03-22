class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "bc82064bc32a83bd4d4d7f4fccb8579d3ebb9f64073ff000da99b01af508b40f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe6c3f867db6417705d5a386778268604682b76032bb4703d457a44a683e42a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fefc7c95d40b0ba98d46f8588d4a7edf46f464a453005c7c3c2235e201542e1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fecd4cdaa0d07fd459af6007d18a45eb3aa7b2cb9fa38bbc1717032b9c38cd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d554091097e2c15b4315d57203fe55a26e897a3047ddca2fe8c2d8ad2c847f28"
    sha256 cellar: :any_skip_relocation, ventura:        "fbb569071ee37192cfc01d0d04ae83a8c848b34b2e58189e05bb1db3cb392e27"
    sha256 cellar: :any_skip_relocation, monterey:       "9874583405a26039b970616027fbc0619d3ea87a1e56d7fbf118765e34f0d6b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f373cc2e2b69eb72afdaa3a1cc1b13c37bd05b19f222ac261a5dca28583391bd"
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
