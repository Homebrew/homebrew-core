class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/4.3.1/tkdiff-4-3-1.zip"
  version "4.3.1"
  sha256 "832da430a66be06e7406edd620c10ac922f16b00d071334d4b9c8267f640901f"

  bottle :unneeded

  def install
    bin.install "tkdiff"
  end

  test do
    system "#{bin}/tkdiff", "--help"
  end
end
