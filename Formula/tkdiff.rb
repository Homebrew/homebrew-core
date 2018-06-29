class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/4.3.2/tkdiff-4-3-2.zip"
  version "4.3.2"
  sha256 "101d8ae334407e2916f87547be42fc2fa5f06f716a6664abf9bf350d07a96259"

  bottle :unneeded

  def install
    bin.install "tkdiff"
  end

  test do
    system "#{bin}/tkdiff", "--help"
  end
end
