class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/4.3.5/tkdiff-4-3-5.zip"
  version "4.3.5"
  sha256 "29d7f0b815d06b0ab6653baa9b6b7c213801ce6a976724ae843bf9735cbbde7e"

  bottle :unneeded

  def install
    bin.install "tkdiff"
  end

  test do
    system "#{bin}/tkdiff", "--help"
  end
end
