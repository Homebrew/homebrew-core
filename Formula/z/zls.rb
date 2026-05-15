class Zls < Formula
  desc "Language Server for Zig"
  homepage "https://zigtools.org/zls/"
  url "https://github.com/zigtools/zls/archive/refs/tags/0.16.0.tar.gz"
  sha256 "e7c5936f5b3a057ce851be0876e4e259b5c4d02f9aae038cd24a5d6b586b029f"
  license "MIT"
  head "https://github.com/zigtools/zls.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "cf9e3dbfb7419d15afd803c01b382559bc0e831b104b31531ca97d4dd2f384a0"
    sha256 arm64_sequoia: "ce22366300bd0295a20c0acbfdbc9608215d754f9e93f011ce10bd25784c42c9"
    sha256 arm64_sonoma:  "e1310f07fa055942ab21a8840e87839285e9e7920bd52b1394fa7ca377328a64"
    sha256 sonoma:        "bc2060d2718fce996369259c37f10d2098056c2ad259ab1254d4705afaf0cee2"
    sha256 arm64_linux:   "04ccd93662797e910e75c055d8f07b80ce5ce9539a53e6d89a7daa1cba7f20a7"
    sha256 x86_64_linux:  "fb7b67209a45f5160964cfad2cc7999dece484155908bdce620a3f554641ca36"
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
