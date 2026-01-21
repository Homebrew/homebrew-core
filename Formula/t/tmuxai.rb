class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://github.com/BoringDystopiaDevelopment/tmuxai/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "e6de2038f7af82f11b6b3780684a737f5922db175f6298617f94f42a8bbc7ce1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21c0d6c8ca6109978def90e47719257a971c7a5ff8557b873d7425ce873f307f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21c0d6c8ca6109978def90e47719257a971c7a5ff8557b873d7425ce873f307f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21c0d6c8ca6109978def90e47719257a971c7a5ff8557b873d7425ce873f307f"
    sha256 cellar: :any_skip_relocation, sonoma:        "66c4fbbc2f883303b924e19723d448f0313db3ab8d45df65e4993f02134fd9b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eba30c6f393f722e1bbe2fcf3c5ce8e900701ecc08f6cf1a45945cf97ea96a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aa42f0436c47e94b571e737e9e9f227b0f131aafc8e88ec76df2681dbc32d1a"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.com/BoringDystopiaDevelopment/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end
