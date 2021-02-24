class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/5.1/tkdiff-5-1.zip"
  version "5.1"
  sha256 "016569ac1e10b4bfd7c6ce34fece75ee486577580087666dcbb8c36fd7eee87a"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/tkdiff/v?(\d+(?:\.\d+)+)/[^"]+?\.zip}i)
  end

  bottle :unneeded

  def install
    bin.install "tkdiff"
  end

  test do
    system "#{bin}/tkdiff", "--help"
  end
end
