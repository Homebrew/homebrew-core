class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.44.2",
      revision: "e50a6dc4b43e2183e245aded8d23f0003d8c6bf7"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "4bdfb2bae2ea0e6651f3880e20163094d0a9e434b8f45595f74dd97174297bd7"
    sha256                               arm64_big_sur:  "8d2bdef34ad980b87a793e6f67490e68a647162f5294b6e005cb4737eca29089"
    sha256                               monterey:       "53cdf43975c36f6759dd78b0d94c7511ed06b47f1350a41f346b3c67b32c21ab"
    sha256                               big_sur:        "cc5a0e00350109e2ce3dfc09afd60b427fc20416bfcfeb68dd5fc4de96682e29"
    sha256                               catalina:       "572e7ab925e723236509671f9a10f2814417c41771c81b3e155dae990ead1179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ea302b96d25305df9675aa39f2ab7270cfdf81c13f977a69dcc45abe5cca860"
  end

  uses_from_macos "ruby", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    require "open3"

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

    Open3.popen3("#{bin}/solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
