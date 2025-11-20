class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://github.com/alvinunreal/tmuxai/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "c8bea8401ee7466b3af1efc04d1ac85aa80ecd01dc3c6fa2268628455344d7d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2185b850a029c79568f034a304f77551c630f97039323665a0a65d8eb56ce2a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2185b850a029c79568f034a304f77551c630f97039323665a0a65d8eb56ce2a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2185b850a029c79568f034a304f77551c630f97039323665a0a65d8eb56ce2a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c3129db83a86a62bb92c64d65260851f8d4268dbefe279dac6623ec727e3070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12fc511866d15d16690b25ec0552d0f52f65dd41cbabdc05009fb98b5a6667e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c4941d5128546a3f7e61e93b63e6219add1414cbba0f606480a4965bc803187"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end
