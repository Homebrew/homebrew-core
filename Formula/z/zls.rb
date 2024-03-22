class Zls < Formula
  desc "Language Server for Zig"
  homepage "https://github.com/zigtools/zls"
  url "https://github.com/zigtools/zls.git",
      tag:      "0.11.0",
      revision: "5bfff2a4b9ee01a7bab5fc26fad6e174f289c28d"
  license "MIT"
  head "https://github.com/zigtools/zls.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "1866605a7d3b4dd42e66e2fcf78bd80541ef44334de24f23315b999065fe5bd2"
    sha256 arm64_ventura:  "ed5d2f6503f42691ac89599e5cafc87e220c0b72f90b59108a3212faccbf5990"
    sha256 arm64_monterey: "9119d879e10ebfe1de831340e2a4abb70d97c96e3af87f05b99e24b29db44bc4"
    sha256 arm64_big_sur:  "706e23ca5c57b425e55109c98caababa09ac7ca8377554218a809f0d8fb122d2"
    sha256 sonoma:         "aad81bb0753a93beb5f5e59a01300a643b9a9c35a339fd9747eba30d16bed81f"
    sha256 ventura:        "30505ce3201a97387aa696eaa2dcc6055a46ff8dd8ec96c26afc8723c932da76"
    sha256 monterey:       "3f2555ad020179925949d6f972f0aed5f706f5eb8cfc4306a3b779e6b07eff03"
    sha256 big_sur:        "01e0af8de1a237b5a1cf702a3a011968e145193d17607ffbe656c28d956b2c8a"
    sha256 x86_64_linux:   "d09a679d60dd36ed4e02b56af14628af478678ccf049885d0c2922cccc85d443"
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
