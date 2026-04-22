class Smctemp < Formula
  desc "Print CPU and GPU temperatures on macOS"
  homepage "https://github.com/narugit/smctemp"
  url "https://github.com/narugit/smctemp/archive/refs/tags/0.7.0.tar.gz"
  sha256 "4ca4eaade1964f2d4d39c5fc21ccb357a1966c5c2b8bb1480b08a28d47f8d4dd"
  license "GPL-2.0-only"
  head "https://github.com/narugit/smctemp.git", branch: "main"

  depends_on :macos

  def install
    system "make"
    bin.install "smctemp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smctemp -v")
  end
end
