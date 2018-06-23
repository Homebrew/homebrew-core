class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/4.3/tkdiff-4-3.zip"
  version "4.3"
  sha256 "60acdb57da030a5697e801996e30ae7d3a49f60898abdc63286bb7be98b58bb3"

  bottle :unneeded

  def install
    bin.install "tkdiff"
  end

  test do
    system "#{bin}/tkdiff", "--help"
  end
end
