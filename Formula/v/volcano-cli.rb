class VolcanoCli < Formula
  desc "CLI for Volcano, Cloud Native Batch System"
  homepage "https://volcano.sh"
  url "https://github.com/volcano-sh/volcano/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "37f83d4ca9ed360cf459e2d3bac7eaceb15b10ae2a1b2bd95e62bbd52ea7b04b"
  license "Apache-2.0"
  head "https://github.com/volcano-sh/volcano.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "336637eef6c22f616b08ed55b6ebd8904341bf77212ad8d647e3cc2dbaa338eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "202c40248e57758f73b9c8c336ee17458b7937f1f9102b02615f0d0585a360fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71b878597cb21cc10bf7115c3c3477e21fb0ce8b38f348ad9f526a1eaf5f51f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "529ed9f65d75e26e485a90d2b5fa9b058d5dba6526f492353c26e0997f0a5580"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1437406e1a56b9042633c68a87079f4da0c55a9a9d12643e8a019988147c4444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dafcfddad99416a966369abb029fdcb7a49495e6e33234af7b8d323a924819c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
