class Scry < Formula
  desc "Code analysis server for Crystal programming language"
  homepage "https://github.com/crystal-lang-tools/scry/"
  url "https://github.com/crystal-lang-tools/scry/archive/v0.9.1.tar.gz"
  sha256 "53bf972557f8b6a697d2aa727df465d6e7d04f6426fcd4559a4d77c90becad81"
  license "MIT"
  head "https://github.com/crystal-lang-tools/scry.git"

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "pcre"

  uses_from_macos "libiconv"

  def install
    system "shards", "build",
           "--release", "--no-debug", "--verbose",
           "--ignore-crystal-version"
    bin.install "bin/scry"
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n" \
        "\r\n" \
        "#{json}"
    end

    input = rpc '{ "jsonrpc": "2.0", "id": 1, "method": "initialize", "params":' \
                '  { "processId": 1, "rootPath": "/dev/null", "capabilities": {}, "trace": "off" } }'
    input += rpc '{ "jsonrpc": "2.0", "method": "initialized", "params": {} }'
    input += rpc '{ "jsonrpc": "2.0", "id":  1, "method": "shutdown" }'
    assert_match(/"capabilities"\s*:\s*{/, pipe_output(bin/"scry", input, 0))
  end
end
