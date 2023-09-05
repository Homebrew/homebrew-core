class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/v2.3.1.tar.gz"
  sha256 "d6aebaca1083ee3e5d6494f5574931691bad239a98e8fe99655790a40f2cb80a"
  license "MIT"
  head "https://github.com/sindresorhus/macos-wallpaper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "183473f47ee0c0756b878ea79b9b6af7c1a1ee99e15f2142429a04f599f5695d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f020cda2a5cafba2c001ae6d32cae25d0f63283c221fd3ce75dde1414e97a19a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c730b0f63bdf5395221ab3c45018e23e31b782a31e379691947f1b0199381ba4"
    sha256 cellar: :any_skip_relocation, ventura:        "b726b99912abf74b4a5d3f0cf265dc2986e3ff1302c600cc74b312ec34e4f1a2"
    sha256 cellar: :any_skip_relocation, monterey:       "a4ca40d5df4a1983cc719122135a56d19f6861a216c347c984a2b7f89c4e4d4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f8fcb711d2e7a94dcef1894d6f23c754e950b1773f7a3da008cb5dd59696dfa"
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
