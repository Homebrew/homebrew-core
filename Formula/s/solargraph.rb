class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.57.0",
      revision: "9c707a291291ef6b86a030bca80b92b4cc3de7d0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da52af7a6bfc1dbead71eca2fde7908c2faa2b388151aec229d40ac1a6a091bd"
    sha256 cellar: :any,                 arm64_sequoia: "b5206d19e035110287f74c4cef7e113c70b23bf0d12087c0d74eea355d61364e"
    sha256 cellar: :any,                 arm64_sonoma:  "7a05aa840993a08073ba901e7977f285aae32d90162a3e10bf80612475c5cb18"
    sha256 cellar: :any,                 sonoma:        "50fc5d9a0676cbca78cab5c86b8028c6200adf9c92e950c00472d810b9a8fa8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d806c1ebe2389b5067f09558153aed3453abfc6fd45233f7d81b191c2a8a1149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c9f63702530f99129b29adcb133824d55f02d491315fe04c68ae0240a08fdd"
  end

  depends_on "ruby" # Requires >= Ruby 2.7

  depends_on "xz"

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
