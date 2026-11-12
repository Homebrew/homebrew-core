class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "1c679a67b6cef8f05f0fb432ae9e005a9dd4550905d299b96fad807c3436e17b"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "383bac02aa1aede466a0997d6ef177073f160ba64960417ded57faa615f7a16b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af971b2e5da6618aa868b24108bf3457ac784ac3c46c16b7ca90b392042306e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "68497b8bdde49d3c0cd5ab5775089e374061ff44c2d3a139935bb83fb9502638"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5684674186ebc2c4e6052e79f107dc53a20e8223b4cb991f055e326e04da9a26"
    sha256 cellar: :any,                 x86_64_linux:      "522a0cc36ac589a3d0e022f3c05131e68f444ee88c295c15fa6b3e6e89971c16"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tgpt --version")

    # The free default providers keep changing their access rules, so query a local port with nothing listening
    url = "http://127.0.0.1:#{free_port}/v1/chat/completions"
    output = shell_output("#{bin}/tgpt --quiet --provider ollama --url #{url} 'What is 1+1' 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
