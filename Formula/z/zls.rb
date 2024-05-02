class Zls < Formula
  desc "Language Server for Zig"
  homepage "https://github.com/zigtools/zls"
  url "https://github.com/zigtools/zls.git",
      tag:      "0.12.0",
      revision: "68cd4ff4c7b84e89bd1e1b4ad29f9abd8b020174"
  license "MIT"
  head "https://github.com/zigtools/zls.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "db9414901af8a8f0fecc8f160737bf2cbc54c2ddc064360045dda755f293c51b"
    sha256 arm64_ventura:  "05bfd37adb678e739719dc7c29d0f73295c7e5a70e3275f20f3ee541c10fac8d"
    sha256 arm64_monterey: "71cf1b8c3a92e177a06011987f226fad98d52ddf29d0cc7ade038a3b3fc38edb"
    sha256 sonoma:         "a389af165a8dee9b6de1ad1e4cd172767b05a8a4bbf749072215a2ff7fe87b48"
    sha256 ventura:        "a1406ebea301bf4a79ce6073bf1ea58551a8cbcaa7fcdfca7690ddbcda4689b8"
    sha256 monterey:       "ca073e230f3a16311ce6328d375da154fb81569b5fe08727393ff482681e0aec"
    sha256 x86_64_linux:   "80a60f63a55b8472d728617aad4369858f2851728f1ac59470a383f529e12f8e"
  end

  depends_on "zig"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[--prefix #{prefix} -Doptimize=ReleaseFast]
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
    output = pipe_output("#{bin}/zls --config-path #{test_config}", input, 1)
    assert_match(/^Content-Length: \d+/i, output)

    assert_match version.to_s, shell_output("#{bin}/zls --version")
  end
end
