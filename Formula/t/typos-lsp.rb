class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.36.tar.gz"
  sha256 "a09600b077872574566b267be332c620b41f009c485d50ce122094b51675ef65"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee3915e3e9617c1924eab3c8a911ed61fa53b7206c4e4a4f026ba48584b8b5c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f78129f30fccbae78d3ea8694bbefb4fbee51929655929a57ad3a59053f2a4e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "303570d8c7ce686d08c5235ba515b199d3f8e6234b54bcc05078b161e9042379"
    sha256 cellar: :any_skip_relocation, sonoma:        "04c34111dcd0d81a53f844a97db9bec7c7980cb2843c19a10b6d83dd3f36cb9e"
    sha256 cellar: :any_skip_relocation, ventura:       "7c6b085d65cd0c47907967b724326f74a935787b005f4b6eea2187aff61a5ba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17590a83cbffb34775cb3889a4c94517819d32ef1410cf7d6ee079d2d1e37d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26adc0fda5ccba800edb5346be6849ff61a5934322f0f71a7f312d3f49d82332"
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
