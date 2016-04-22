class Wallpaper < Formula
  desc "Get or set the desktop wallpaper"
  homepage "https://github.com/sindresorhus/osx-wallpaper"
  url "https://github.com/sindresorhus/osx-wallpaper/archive/1.1.1.tar.gz"
  sha256 "a1797eac72da83f947a2a1f12b7b85484607d5a218c8254d1ed5573e5fab92bb"
  head "https://github.com/sindresorhus/osx-wallpaper.git"

  def install
    system "./build"
    bin.install "wallpaper"
  end

  test do
    system "#{bin}/wallpaper"
  end
end
