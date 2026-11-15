class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "1c679a67b6cef8f05f0fb432ae9e005a9dd4550905d299b96fad807c3436e17b"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a367231f8fa89977cfd19cab193d2fca284aa116262cc88570e60108dcf4b5d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee2dea159ec543f126f51ef4260c80415d30a9d6a71355df64baa3dd6b4e3d72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b54e0032eb2f5eee8732be62ba7ea4d73329cd4023321a24a3893999bd357707"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c227bbb4c0e9c9bf30825c7ece7071ae2af44d46abdf6413e00425c681391d89"
    sha256 cellar: :any,                 x86_64_linux:      "d2c5ce365d7b19e4d42d158dcbd7f108b3bc901ff1671d3feb391b3972b3e005"
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
