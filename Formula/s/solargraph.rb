class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.56.1",
      revision: "4baaaeb1453cb5171d78199b5ee6df7a69ac6738"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fffcd20af09af30d5452ba79b5049eba1a0536e4c015301c47ad679afab45c32"
    sha256 cellar: :any,                 arm64_sonoma:  "aa73d3e4d83d25e8d3ac1797063e893229778dad903a03f8e757debbe09c1396"
    sha256 cellar: :any,                 arm64_ventura: "23beee3cd2bb49c8e2c4e5e0260475cb6d5dd0ec1531c8730168216535f001e9"
    sha256 cellar: :any,                 sonoma:        "df20bb187c596c3c187038e1065b44c589b51032484e72e95928f598ac141512"
    sha256 cellar: :any,                 ventura:       "f7a769683913fb36b371ce528644bdb72b4992a2591689302eed289136036634"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1af5980d100c14901fee0a858c34b96a6176e913324de3a6fa359861dde02778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d974c3f436f7af8b11c99c719b4273f10662241f7444f996b798124c87a0afd"
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
