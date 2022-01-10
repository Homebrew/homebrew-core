class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/v2.3.0.tar.gz"
  sha256 "96a7549b45aa166067a37099f6aaa6c2f5753c13225b1dd2cbea152ac7147818"
  license "MIT"
  head "https://github.com/sindresorhus/macos-wallpaper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2642f357a9594555d68adbedc29046810f800410247665d41973e3163a289498"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae7b068e0bf64012d7e53c43275945d0c4057ad535fb6c8c173f44ebb78510dd"
    sha256 cellar: :any_skip_relocation, monterey:       "dceff456bbe229c00b21954761965f2763c96c49255aeb0ee20de0eb287a65ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "959aa285c16932fcf4efc31cc73d99ebc6651c105b7cfeeb6d5f42bafa28b8bd"
  end

  depends_on xcode: ["13.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/wallpaper"
  end

  test do
    system "#{bin}/wallpaper", "get"
  end
end
