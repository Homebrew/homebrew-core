class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/4.3.3/tkdiff-4-3-3.zip"
  version "4.3.3"
  sha256 "a85652b03f17b88ad438f0feb76dd2cbc88fe817df27ed2279d940e973ca6aa9"

  bottle :unneeded

  def install
    bin.install "tkdiff"
  end

  test do
    system "#{bin}/tkdiff", "--help"
  end
end
