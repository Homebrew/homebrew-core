class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.55.tar.gz"
  sha256 "30ad727ea2321e3c0554329882e92d18f5596a7ada0d2878d15e7b43b2907443"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1325af46277e89b6e2996b929bb1180600ab394c331bebd48e725a88a05a38c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c87c3c7300d8f5d5e21da1343b3d7a9ba0921d0ac53d70210f0a21e977ca22d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aaad8b6c1e159059411bf810a92cf63b8486df97a2f7db38317dace932c3335"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c8a01957f8dc03f48a917b6e9e3633032728b2602a044c030a02cb91b5190a1"
    sha256 cellar: :any,                 arm64_linux:   "522b1b8daddb9a2f2c7d74820a0e8917e35570e90e7ee3415177fb2b79c7c867"
    sha256 cellar: :any,                 x86_64_linux:  "126e3e8a791abfdc898c82a73bb3384260b3ab58684bd1c24cf33b639a2ffdd8"
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
