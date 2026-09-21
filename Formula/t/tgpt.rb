class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "2dd4e1e5c51243e2a373eebaaf85441f4d418def0a962325ff6784bed2aa874d"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d99b4c2cc802c74aef0fdb98891b0680036dd38ad82cc7b04b4c24da01e45a44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78c7d0721e5e5715ec1e41f6a87cf138fa2b3c144dbcc1eb8324af8577ea303c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ae0c0ef235c31c2a94a2fce8683f0e4c4f094d9898b90ec29a544ad5d68efbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "652b5fb211516a4c504523c2c5f2357474b8ba60fa1633c6786fa9a0615d31d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "77a6ce761d4d14d661752457f7c7126eb5399a04a2bf1b429a51e16eb4edd7c5"
    sha256 cellar: :any,                 x86_64_linux:      "f65ed57eae124140dd732d5c0a5fe1a3b7657b53893777c9760689f116be1a0e"
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
