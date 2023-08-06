class Smctemp < Formula
  desc "Check Temperature by using Apple System Management Control (Smc) tool"
  homepage "https://github.com/narugit/smctemp"
  url "https://github.com/narugit/smctemp/archive/refs/tags/0.1.1.tar.gz"
  sha256 "2205fda0fcebfc464b470f0db841124a00d85934f1d6567198c37977549112a2"
  license "GPL-2.0-only"

  depends_on :macos

  def install
    system "make"
    bin.install "smctemp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smctemp -v")
  end
end
