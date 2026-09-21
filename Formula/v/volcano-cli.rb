class VolcanoCli < Formula
  desc "CLI for Volcano, Cloud Native Batch System"
  homepage "https://volcano.sh"
  url "https://github.com/volcano-sh/volcano/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "047a2b05dc4a263e06b6debc5eeffb78cc8c782d71c1d3a7b30a0714b9927acd"
  license "Apache-2.0"
  head "https://github.com/volcano-sh/volcano.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9598381fded7ee138c7e7234e54284723c9ae27227a86b1f48b497a075c23b71"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8ed7e197d008959cd3ebf0455eca8f35345e3c3e1bdf102746ad401094ffce0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5035763ecb4e7cfae00f665729f092cd7fec132d3fa465b64a180809b67efa86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6fdd66c6126b09caf8ec8cf3ab608615a31ff4a53330dfae0e9627a00bf416cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "93682ba0188d07e2b76e9f570d6abfd15394941efabd07c627ba28337161eefa"
    sha256 cellar: :any,                 x86_64_linux:      "65fe3400d1c3d9fc84915cec5cbc6693bf5c33eb555377fef9ff4e429e504072"
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
