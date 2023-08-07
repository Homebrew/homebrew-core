class Zls < Formula
  desc "Language Server for Zig"
  homepage "https://github.com/zigtools/zls"
  url "https://github.com/zigtools/zls.git",
      tag:      "0.11.0",
      revision: "5bfff2a4b9ee01a7bab5fc26fad6e174f289c28d"
  license "MIT"
  head "https://github.com/zigtools/zls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57e41a00eacea3a15f363470b5a64f6da2a7002cd69692df83910cbeee3bbe0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f7686c0ea862ad5ab3ae4431dafadf9a28951bb7854e7e7c02c359d63caf0dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c75a6b48d33d6b129b020c0e227f6df7107dcbbf9a296d74f52397d8b2234836"
    sha256 cellar: :any_skip_relocation, ventura:        "ba4279657dc4293a8261202ba7553a3f72254556e7b32b0c49586090f0ccb9af"
    sha256 cellar: :any_skip_relocation, monterey:       "035e8403b2a33986d35251e49a1db2e18f1892bd1a3f029e069e44179537d5ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "8883d3da3be2111f3b1c569027d6454ac627891de95d3268303275f995473ff3"
    sha256                               x86_64_linux:   "96c162fc09934028b9d3e2f10703e1f2f23c4ce8c9737b5e62fc4b54805f075e"
  end

  depends_on "zig"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[--prefix #{prefix} -Drelease-fast=true]
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args
  end

  test do
    test_config = testpath/"zls.json"
    test_config.write <<~EOS
      {
        "enable_semantic_tokens": true
      }
    EOS

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
    output = pipe_output("#{bin}/zls --config-path #{testpath}", input, 0)
    assert_match(/^Content-Length: \d+/i, output)

    assert_match version.to_s, shell_output("#{bin}/zls --version")
  end
end
