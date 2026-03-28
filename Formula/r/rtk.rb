class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "d5ff335f9b124d8ce8b9074ea969d4585c827533bd2c66bd235f6f43092ed175"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5802dfb121700430725513bfc78bfbaf15e9746a99fe17d0a5050c6fc860f07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9302d32f92190a625ad84a61a54b45fba48dc23e76d3a9c90170306d4e2df14b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d160fc97f16353aae9a0869e383348f241b6265adc716a2a65966fb11c1cb8eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dc2aad2b2025af8d17b77a55ff4ccb6582c48d720691efc037949f8de7a7122"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "017d81dc6d675ea5a625bc9c88e59f0d2b1b44304f8ea4590070ff8667d1d160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33726d67e7e50836a56d9978d8ffb0e0fa8fbd161d5eb7eb0d822bdea9747a58"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end
