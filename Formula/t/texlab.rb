class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.14.1.tar.gz"
  sha256 "506fd5e4fd5c82358035bd3c6a99fcb0ac19fd1033e0dd97c0078ec23a13dd55"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ef2b6a643eebd2153ac33b686926833c00d09b978a703a90446b7546b132dbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "753d5da5f318ecc936d591078deb45cc975ed1c91a390856d09d7e1bcc8358f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c26d4edc296eb6aed2981a73cc0c31a7f41883530cb3bae103ae86fee4ffec4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d52fa3590f4d5462f6708b231c322974a1639b301aa3a57a8bb468c714aab627"
    sha256 cellar: :any_skip_relocation, ventura:        "6e5ec53465984bd2f0b22c478843ea233380f520085b95b58a0abdb718a7b088"
    sha256 cellar: :any_skip_relocation, monterey:       "361cef48c26ea10427f25640f0ebb3bd54ec3b2b882dcb9fbfa77c6d49a40a6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53d8d8b9bb2a8d12f98cb84215f27053ddb49ab79db74e326a61f9cb3795661f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/texlab")
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n\r\n#{json}"
  end

  test do
    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/texlab", input, 0)
  end
end
