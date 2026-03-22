class Zls < Formula
  desc "Language Server for Zig"
  homepage "https://zigtools.org/zls/"
  url "https://github.com/zigtools/zls/archive/refs/tags/0.15.1.tar.gz"
  sha256 "40a4559c3007ed9333769fc3e111ed466403b53f31ad9242874a62ab385b331b"
  license "MIT"
  head "https://github.com/zigtools/zls.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "912517e70986dc8b31f03dd170ec42e4656b011839a7b9be0c411d9e15d3ed90"
    sha256 arm64_sequoia: "722bdfcd3532ddc387d0ee1c01f08f89c5b95e6bc9f4a21bd35e8ca3ad9a2fdf"
    sha256 arm64_sonoma:  "911834f15737777240a5067d7fca4fcf0835447b23a3859fbff8eb1792a9aa4b"
    sha256 sonoma:        "62af47f178f960cc1bce1b884e20fa4152f36773d4b70a51dee9da6a5d8b866c"
    sha256 arm64_linux:   "35c82e4a09bf0942d42852ba9a0d57ba07912c286af306e0746aa7afceb86101"
    sha256 x86_64_linux:  "e1047a7ce5b87627cb4f024c7466db76e41e06f888164a8d0174f9901f48f287"
  end

  depends_on "zig"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args
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
