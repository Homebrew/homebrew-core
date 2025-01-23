class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.33.tar.gz"
  sha256 "413c3b497be6a51033c7e40172b2858c6fb4dcba2486610ef33af751c5ffb274"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b656e90b40609379470d536e8db570d9544ef066f9d1122b197faaf698586f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffc97577aa4cecafc88dc692314e74e3747f8f418d7e175216edefce7c6e64e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b6cc68033f534ac9137ae963f072450e22e5fe0c15c660b6d0e2de50411b7db"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9226cce116c578ad80ee0483277d27ed3c92b9e8f2bcdd94a10ffd3d553752d"
    sha256 cellar: :any_skip_relocation, ventura:       "977bed2ccc5b886302290405c47917501d42a1a8d1a8f536d5ffed8c6e4b96dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35a2961bcb0f228278379e5a900169182fdd8fa887a3fe13ee23138c584531cc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-lsp")
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output(bin/"typos-lsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
