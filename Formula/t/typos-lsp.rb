class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.40.tar.gz"
  sha256 "1ed488e8bb8b3494367894c55efd83a2f8d7a9c986cf5715792b20a257362a6c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "615fcde90b32fa35d947cfb7c62f0fcc96f50cdfc99120850f8afe5f0b966dd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a63462b4704c57d519a413535dc2cb8162a5b99b641aa125d2d458ef63416024"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0c75c95d30ee298b01cbb7a1416a82836475858206ec2a015fda6fdb54472d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cc35290478b85f2576bd5132ded68cbb560e9c406e45543406ad8b60b484028"
    sha256 cellar: :any_skip_relocation, ventura:       "06f80c7015302acf6f823b6f28708367eec0a9c7504c61a92b9824be4429d186"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee25bc3a922ae55bad21d7075e4d28e0c1530795e9023901a1d2b1239f8fa2cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62c82422a7470c0754485c69cd28ef620e7fd261e02de3924030ed1dd01c4f18"
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
