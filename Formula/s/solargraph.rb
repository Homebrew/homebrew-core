class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.60.4",
      revision: "6dcb73338b372b25935406656e696c3ec1179e23"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ec881f62d64c641d218d620f648d28ad0214b7cfaf08a1a99face3ca18b006b1"
    sha256 cellar: :any, arm64_tahoe:       "5103f52a6bab4ca4289a560f5251202f3a59e0c207c4ac4b8c90b6e9e96c2306"
    sha256 cellar: :any, arm64_sequoia:     "205ecc04b48eed322f22d57cbe2649f0eb780027576589c00dd555e951b29c81"
    sha256 cellar: :any, arm64_sonoma:      "df5c26d4ab0a5d367f2596bcdaaccfec523cb8ec5a9b0f6eb5e030e1001b80e9"
    sha256 cellar: :any, arm64_linux:       "ccfd0d368c2043236e7988e01322fe8cd2fc4e64fefee0221826c5b971caae05"
    sha256 cellar: :any, x86_64_linux:      "c36f1ca8b84c22c613b3e80cc79090a330002e54dc7ebcfb007b6f64e69de710"
  end

  depends_on "ruby"
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

    Open3.popen3(bin/"solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
