class Zls < Formula
  desc "Language Server for Zig"
  homepage "https://zigtools.org/zls/"
  url "https://github.com/zigtools/zls/archive/refs/tags/0.14.0.tar.gz"
  sha256 "44cae74073b2f75cf627755398afadafaa382cccf7555b5b66b147dcaa6cef0d"
  license "MIT"
  head "https://github.com/zigtools/zls.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "7c368a129e8f7f77847510de90e109b6c01e35901f065327551bdda25c9bacc4"
    sha256 arm64_sonoma:  "660c0950e552712568b2a14230e6d866cd6f16c48cfc4fb4b9bbd8d4b4708979"
    sha256 arm64_ventura: "8f9f6f64f69751589f4e9c746f1bd8c07d1364dc104bd68654f32cb5641b0856"
    sha256 sonoma:        "5fbe4882be0c8049da4fe626e6a0dd1adf6cda6d6f561c92765c0454d9967cfb"
    sha256 ventura:       "667924a98f0b4de9cbb5df7bf8f14da4b26cecd53c0dd4dcbf746a85274375e8"
    sha256 arm64_linux:   "5cfedf309286303cdb7070ea8693607a4fa12737dc1685721ff717a25e7a0df2"
    sha256 x86_64_linux:  "b99285236749312380349bc72d1c109a9108c439ecb4381c228a95b469608c07"
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
