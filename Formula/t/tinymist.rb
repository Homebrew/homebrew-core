class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.13.10.tar.gz"
  sha256 "f47897ad9572bdcf84bca196946165531fa36933eb5a72101dc711dcefca44ae"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d9e2a6ab5e12f44fb3c84432ce49390f52f1b37f18961217f86477a38179853"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a849de011cfe27a45a816f99c67cddbd6d549be362d2e89a8a8a8f9d2d190bc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c0cddfaf9f692c662e36aea51cf4a9d5a2866ecdc5e4832a375ec826c915bfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "0166f2e656ae050b76ec2a838c4f161049e6bff79d8cc3856305f5deae51cd5d"
    sha256 cellar: :any_skip_relocation, ventura:       "4c32e994f268e7bb31d7d2ec4ba01648e1ec1e279f3d69c7eafab66be5279a84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bf0c2172cfcb23b89182b44c1fc8d9505ba0444e667f06e19862688dfee7348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8199984145db2aff0533abb134d30084811b23f3a4953aefe5bf0334b86c8a14"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist")
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
    output = IO.popen(bin/"tinymist", "w+") do |pipe|
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
