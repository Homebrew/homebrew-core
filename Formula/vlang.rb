class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/0.1.18.tar.gz"
  sha256 "3f3407a78aca7fc3b42a3fc1f1d2b9724c1e4c71fbd5d37ff12976cd2305cec1"

  def install
    system "make"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/v -v")
  end
end
