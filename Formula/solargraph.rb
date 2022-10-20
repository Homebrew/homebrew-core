class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.47.2",
      revision: "12fcf71755db2d570f591de773753eb73ac0680c"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "9ee4f9c6c6c3fdd9472d4b0edcd2b295759aa1df23f0c32f6cf0cf2cf4af7819"
    sha256                               arm64_big_sur:  "e482fe463b5a4df5fbeb2b04e79b0d2f2e3e610cd5cf497a6f65502c1179bff7"
    sha256                               monterey:       "8c96f3cfa556bf4e88a0b3746925a92ed9ef23653289131a30515e2b1b7fe8b7"
    sha256                               big_sur:        "42bfdcd3acbbf4512919b58ea9f37a9feb66118a86f3f74b04d4354596c7f101"
    sha256                               catalina:       "743ac7d4e922320ca45dc2d179fc6484526f84e737b567a97988dde3bc4cd372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64ad3bfbda1d0df924946e9827cf80ed4fbb79e037c1feb4ce46ddbb6ea48c7c"
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
