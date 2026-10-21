class Zls < Formula
  desc "Language Server for Zig"
  homepage "https://zigtools.org/zls/"
  url "https://github.com/zigtools/zls/archive/refs/tags/0.17.0.tar.gz"
  sha256 "f77940720768daf67c01802ea3cf3029dfd8a74afd7b68b39676c4f814dd992e"
  license "MIT"
  head "https://github.com/zigtools/zls.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "999e91008090c76179cd10f9a51300c4aee17c362b569f3b34dc0e13a6679823"
    sha256 arm64_tahoe:       "d997a2712be7e252c15bdab97ec3508f4cf05cb8918e1fdcfa5874e36b3326cc"
    sha256 arm64_sequoia:     "65246a8d4c16a17044328ba06466e4e1f6b9eec7e06691db96a6c9801b8ac018"
    sha256 arm64_linux:       "7a76f669a2b4917028a6bef870a683b403e0b4e688ab136c55d82adf5f7ef48d"
    sha256 x86_64_linux:      "d54feacbe9cd71284d5d907b3fc79e20ce65e01eddb3f0a837091e5dd4257908"
  end

  depends_on "zig"

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    test_config = testpath/"zls.json"
    test_config.write <<~JSON
      {
        "enable_semantic_tokens": true
      }
    JSON

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
