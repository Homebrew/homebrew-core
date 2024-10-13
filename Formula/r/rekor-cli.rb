class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "15180c244ea11373f268985828ee2b2f40020d09a6886bbc591a4acee97ad53a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dcf0b5be6ad0a039d91d762466f00815291557f0a5b3082ae502cecba94ed3dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3fc84c9e35f1246820c00ab49f8fd040be490378d7bee0e501c4e38049be54b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "777537292bfb1e135878ee833fd25905af9dc24a24c04dde42286d8c2908dc55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1233f61dca15831546ac17a78a767fb78998d7c114dd224a050ae159d175ba04"
    sha256 cellar: :any_skip_relocation, sonoma:         "91a3742f97715cc34a20f2c23b97d7d8403885fb263b12825cf46eaa0d1a4fe1"
    sha256 cellar: :any_skip_relocation, ventura:        "d2eb978ba461eaf36344b44329d6383697d57a6466634b41291cbb69d7937f25"
    sha256 cellar: :any_skip_relocation, monterey:       "cdfbf78cf0c8acb8cc9e0f2ec8f87c85295748e72f2ebeae37dff716cbbb69ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4280fe7989c2e8b4c7548c9e521e3945b14b44f4c2b15bdc5f5b438543d0d79"
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
