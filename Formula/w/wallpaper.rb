class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "9c65948c8d023436609ca06c86bc887e5327457136b8540ef97857efee7954c2"
  license "MIT"
  head "https://github.com/sindresorhus/macos-wallpaper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f166fb0c0e257a267ebd551d099567968dd7297f56791c939768736bf472f3ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1428fc5b443d6a4b0b99844cdf398eea32fb89c4f4f121c16f4cfc73bd2a59bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb9b62511a09dc4ace36a7bca8a0179eb4943eb7feb75a87a6d65874ba31ad55"
    sha256 cellar: :any_skip_relocation, sonoma:        "32d2237aaea91b0e3f63ce6c657c5d6887362f633eaa91d79079a655c89f4dc5"
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
