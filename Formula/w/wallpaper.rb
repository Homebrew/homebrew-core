class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "07838483fe015ae9798b542c1c15e02143bbae85c5f2e6fb51e6923bd76556ed"
  license "MIT"
  head "https://github.com/sindresorhus/macos-wallpaper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f32335062b487623a8128191f5a991409f3be90893ff52e74762a08f129c7940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5748b482f492542189bce07a118dba99c058ac615864247f7127b44551d4f00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6a1e560bda31c57d95392aa21e3e6c1e9d611e89dd96134db985604cc3f52dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1723c93aa42b6b3fdf61a1821db8975d4b2fa031f0fbfd2688f6b558a869164"
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
