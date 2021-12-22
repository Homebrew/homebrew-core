class ShatteredPixelDungeon < Formula
  desc "Traditional roguelike game with pixel-art graphics and simple interface"
  homepage "https://github.com/00-Evan/shattered-pixel-dungeon"
  url "https://github.com/00-Evan/shattered-pixel-dungeon/releases/download/v1.1.0/ShatteredPD-v1.1.0-Desktop.jar"
  sha256 "4f8c47233c655112a93ae0ce454ed0d984fba93903261d135bb799b6f6247a8b"
  license "GPL-3.0-or-later"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    print(*std_configure_args)
  end

  test do
    system "false"
  end
end
