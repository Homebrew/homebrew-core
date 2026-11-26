class VolcanoCli < Formula
  desc "CLI for Volcano, Cloud Native Batch System"
  homepage "https://volcano.sh"
  url "https://github.com/volcano-sh/volcano/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "80326f033d3713904ac5076473106a51f46a510a0ab08739ca21127110717daa"
  license "Apache-2.0"
  head "https://github.com/volcano-sh/volcano.git", branch: "master"

  bottle do
    manifest_sha256 "c802df1aa448bd7f3aac03b349564a32d3b572ece9ae7d2cbb3985791613be68"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eaa6e7a5e5ec8f73f755e9668d76d4e6b72ed7470d419288497651efa4478054"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e68c6ef993b9854fd7fe24a8b4e2d6da08d78576389c41c33e5c6b3d83e30a34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a020105d9b45bbb845978472c263f1bc8df341abf2d0f28069f85116640eb65"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b8b9a2a286af93563b71f90b786a3c804570c59ff63a36071e1917d96c928b35"
    sha256 cellar: :any,                 x86_64_linux:      "ecf32821730d3008c06f0131d66ec6f0bdeab333b87ab5f7068aacbbb846e255"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X volcano.sh/volcano/pkg/version.GitSHA=#{tap.user}
      -X volcano.sh/volcano/pkg/version.Built=#{time.iso8601}
      -X volcano.sh/volcano/pkg/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"vcctl"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcctl version")

    output = shell_output("#{bin}/vcctl queue list 2>&1", 255)
    assert_match "Failed to list queue", output
  end
end
