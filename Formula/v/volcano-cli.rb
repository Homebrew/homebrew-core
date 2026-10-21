class VolcanoCli < Formula
  desc "CLI for Volcano, Cloud Native Batch System"
  homepage "https://volcano.sh"
  url "https://github.com/volcano-sh/volcano/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "334e93a189028f0cf941fcca437fc2511bfeadb6ac6b6c4af5f361a4ccc0ea0d"
  license "Apache-2.0"
  head "https://github.com/volcano-sh/volcano.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f5fd27bb5f58a20fb2c5b8cce5b60d39518cf8b3a7a766f8675eb477f8c50229"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4f13a1232071c51a7887b1c937a0a0d6cdde52a4463e79b3a026c796e03745e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f205b3c7cff85b630ae6343db1c602dd9250957e08d5ea1d0c61d53f9659d9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca60ac075837355ace12e3858ed1223550ee6bfcf81bf79daa3d4816fa958048"
    sha256 cellar: :any,                 x86_64_linux:      "8651bf9ef81cdb30d0ad35faffb44692760279181a76527ab92567703105df70"
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
