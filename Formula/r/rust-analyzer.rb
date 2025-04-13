class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2025-04-07",
       revision: "588948f2676312152122a4caefccd4062b569823"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea002ab5374754fbf381ebecf38d6328d9a97b21d3e2c9e47faa449454c9a298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c327e3d9b91936251a7eb74d682367ecad77420a518d732dde6568583d7080d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42d1961d2f552458774fdc76e35eb8326bb67c569687ecbc25a9031ae79055ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5a7b2393c85a7ea93727c4dd12ae08c61fee0252b820ab6283545f5596b4618"
    sha256 cellar: :any_skip_relocation, ventura:       "5abddac8f09dd8911357053927a77e30a51160e95d8f46a896115d57f996f7f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef7b22fed2551cee0f9085cbd3090eddd1387786a11c25e782a3853b978bdaa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b91fb44c85bd9cbaeded3ed54551b653bc2776f5d05961a46628e0aaa213e799"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end
