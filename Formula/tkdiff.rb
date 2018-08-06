class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/4.3.4/tkdiff-4-3-4.zip"
  version "4.3.4"
  sha256 "b75413f1832b2d6f28dca21445eb5661d7aad50fe5ea7d34e19da53f34955f0f"

  bottle :unneeded

  def install
    bin.install "tkdiff"
  end

  test do
    system "#{bin}/tkdiff", "--help"
  end
end
