class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.47.tar.gz"
  sha256 "f8e427e0340c3d212541ab6350ae52c971a0b0607c0c9cdd2215616b27d12fc4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "687ba0edba02f7f64cf1fb9f872b316bcea5466272cad6f083f7b8deb13dc804"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b947c893be50e5b6dfe77bb6b38b1634e94effa65d84f21d8bf4fe2f19d21796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64711962bada527af01393a4a336f4defb59fbe33d24684a66b57cd409f7b1aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "197792f1868b4e23ba51f1aff0908719c6487abc720c3bc4bf0febc5f47e1a91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30a93558ca995194fff44149e05f857b39c13647fcb458fe57a3edb53dd1d2b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb1485cc4290174dddb8e316d06a24ac6cd3b42fe5b10dad55477263649c0162"
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
