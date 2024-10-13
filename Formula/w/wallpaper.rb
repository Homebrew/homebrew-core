class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "9c65948c8d023436609ca06c86bc887e5327457136b8540ef97857efee7954c2"
  license "MIT"
  head "https://github.com/sindresorhus/macos-wallpaper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1428fc5b443d6a4b0b99844cdf398eea32fb89c4f4f121c16f4cfc73bd2a59bb"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/wallpaper"
  end

  test do
    system bin/"wallpaper", "get"
  end
end
