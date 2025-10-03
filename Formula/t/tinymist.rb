class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.13.28.tar.gz"
  sha256 "ae09b85d09951a37aff90f2d3fc5fd36769b88f8e3c5abaafa60cd57a0eebec4"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ef51f1ed81c09ee6b4170e701205c4518a3a53673394bd36b08c5c50ff57c7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccc12bf9a5d77bc3fcb654852976f3cd07ac7f5698ce70ab75de33e5a29644cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e20d4a914974ccbae810bb37ad70bbc2e721befcf3c36690414fd597ea485857"
    sha256 cellar: :any_skip_relocation, sonoma:        "faf52b08ee6e98441ff8cc251765fca9c7ea6f82a9d053ff3d79576ac625f66b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d95b334f3b3ef00dcbf5b914ea6b6549e7f97a7d157b97706735c91a91eb9c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "548bd2b8109eb3b1ee433a4754120f7f22cf166ea508c09e4f37ec6b67cedda2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist-cli")
  end

  test do
    system bin/"tinymist", "probe"

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
    output = IO.popen([bin/"tinymist", "lsp"], "w+") do |pipe|
      pipe.write(input)
      sleep 1
      pipe.close_write
      pipe.read
    end

    assert_match(/^Content-Length: \d+/i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end
