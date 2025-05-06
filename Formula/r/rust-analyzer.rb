class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-05-05",
      revision: "3b57c001518aeb42511e177221f98ecf42104016"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16c156616b83e1b3ca318059dc25dc4561286c35b4ad19708cc1e5bc716a25db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a75663e7b1ece5cf7aa87e624a1ffedbe3931422c41258eb5344d8999af3330"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "327f6b312ed0d17e768c4c77b31feb27fc4d617ef64b385961b53147110ffe03"
    sha256 cellar: :any_skip_relocation, sonoma:        "657b09096e8df7f03d4362e5239d7b64cc4f05e85a13f06107b9fcce4d982f52"
    sha256 cellar: :any_skip_relocation, ventura:       "e71026185d11953c18b2fb190448e14ddbace51935b5a65b9dd675bb36d87b65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "982420d1991fa9d54efe50bd99ffc3e1135472c7f9a7492576a876dc57cd83c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71a9a6f1e3474463980b25c5ee5e0c00a7273e016bc4b925055593b7385c2fe1"
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
