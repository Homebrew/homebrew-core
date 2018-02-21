class Vpm < Formula
  desc "Vim Plugin Manager for the new native package loading feature in vim8"
  homepage "https://github.com/Waasi/vpm"
  url "https://github.com/Waasi/vpm/raw/master/vpm"
  version "1.0.1"
  sha256 "539e3935236b49f0c462404c7ad0cf01d9b860746b1068121d96336a99c54988"

  bottle :unneeded

  def install
    bin.install "vpm"
  end

  test do
  end
end
