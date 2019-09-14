class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/0.1.19.tar.gz"
  sha256 "7fa2b45f88e5653b82ce92532c2cc7631f7646c8eec24763757d62657115be6a"

  def install
    system "make"
  end

  test do
    # test version CLI command
    version_output = shell_output("#{bin}/v -v")
    assert_match version.to_s, version_output

    # run tests CLI command
    assert_match "OK", shell_output("#{bin}/v test v")
  end
end
