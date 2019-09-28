class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/0.1.20.tar.gz"
  sha256 "8102b48b2c82be6be14633e76e71e215aab5221198315436f97be53e1abe1f5d"

  def install
    system "make"
    bin.install "v"
    bin.install "vlib","compiler","examples","thirdparty","tools"
  end

  test do
    # test version CLI command
    version_output = shell_output("#{bin}/v -v")
    assert_match version.to_s, version_output

    # run tests CLI command
    assert_match "OK", shell_output("#{bin}/v test v")
  end
end
