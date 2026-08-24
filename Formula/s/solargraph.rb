class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.60.3",
      revision: "8fda63384dcf19568fdbf591b6e17d239c499e20"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3a6877a4307fb334f99bc11626666498ce340d099ce753914ef7a440e082ac2a"
    sha256 cellar: :any, arm64_sequoia: "4aef819678e677736cf4e075ed0a217a56222a7aacb4c79c2bc98cbd1e72b190"
    sha256 cellar: :any, arm64_sonoma:  "3f7e60e926567f7e401d1467b286c1266f8893b76d7702d0a2947cf27b4dfed6"
    sha256 cellar: :any, sonoma:        "fbda74bcbdab0530f7813fe9b97ee48bf884b8ce1e27b49f8a24424e961c594e"
    sha256 cellar: :any, arm64_linux:   "4de872d36a163b9dc61a41f0cce087752a89119df4384efc0753726194aa7b03"
    sha256 cellar: :any, x86_64_linux:  "5df5dbc09d29411486499b427ad8e25f79d71f3ce3cd58b7f8a3892115a8f54a"
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
