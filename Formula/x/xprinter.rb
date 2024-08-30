class Xprinter < Formula
  desc "Driver of xprinter"
  homepage "https://galaxycal.github.io/homebrew-xprinter/"
  url "https://github.com/GalaxyCal/homebrew-xprinter/releases/download/v1.0.0/xprinter-1.0.0.tar.xz"
  sha256 "2bacdf67ca39448f2cf78a79f9a58c3ba0c070dd111fb90c4496c28d8572ff95"

  depends_on :macos

  def install
    on_macos do
      bin.install "xprinter"
      bin.install "xprinter-server"
    end
  end

  test do
    system "#{bin}/xprinter", "--version"
  end
end
