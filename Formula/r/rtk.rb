class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "35d20bf5da0480931879efe609e3fc66d6eb0c23252204a804d14e72d1baca49"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd8231a5efa4ea93a626cd4a5fadacf9243cae32b0cb3c067aa3374116efc08e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d31a12919e3bb42ccf997f74ae84a85fee2597ab2275ac9c78ca240db50624dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5153aecd9d660e91ff842c4a0935a9aa1664e825d111d23607402096d63c81d8"
    sha256 cellar: :any,                 arm64_linux:       "04ec62c85268de0a1450a89963ee8463ff41b10be928c0f87c10506027692c4e"
    sha256 cellar: :any,                 x86_64_linux:      "e2fe6e19503c1910d03554909d5511ad09be5531ebc62202224e2dcf88f64132"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
