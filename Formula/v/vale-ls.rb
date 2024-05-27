class ValeLs < Formula
  desc "Implementation of the Language Server Protocol for the Vale command-line tool"
  homepage "https://github.com/errata-ai/vale-ls"
  url "https://github.com/errata-ai/vale-ls/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "3daba73d517a27c1243b85075adff6388cd195294f741ca34fc6f75bd8251ea1"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
    output = pipe_output("#{bin}/vale-ls", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
