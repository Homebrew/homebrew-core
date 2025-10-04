class Zls < Formula
  desc "Language Server for Zig"
  homepage "https://zigtools.org/zls/"
  url "https://github.com/zigtools/zls/archive/refs/tags/0.15.0.tar.gz"
  sha256 "337d478ca90bab965070ed139408909f1968ad709afb61594b6368dbacc0b631"
  license "MIT"
  head "https://github.com/zigtools/zls.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "8fddec79c658908cbf4794ea01ab4b8d10a396cf439212e42896305a8de63229"
    sha256 arm64_sequoia: "38274d9f3cef277b88d3c636617dee89116a83d4548af550952745ec5a7ca8d2"
    sha256 arm64_sonoma:  "c4a13d39282994fc19ed778b10a5bb46f530a7ba5c492fd0421e716998b8029c"
    sha256 arm64_ventura: "06745c6f0fd395ab05cb47098cb0203eb7230c984e1bc4f529c0d4e77d8168fc"
    sha256 sonoma:        "90216dea1bf825e145c2c2bee714fb8f911b5e1e7980bafb64d1e4e57b4d3f64"
    sha256 ventura:       "a4049fab19d8e9b8f3638d2c4ff1d85742fcf93c60884eaf5d26a3ba863daf38"
    sha256 arm64_linux:   "77b5ba24e47f3df03aa0cc8d7d1f47d1e88987fe2aecd9c2da5117422cfbc7e5"
    sha256 x86_64_linux:  "adf7d9b4b52da29abf507a1536b7e30c28f96cf53998cf8ab1ce13bdc54cde98"
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
