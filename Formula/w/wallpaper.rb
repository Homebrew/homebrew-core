class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "29b841d2a19edb609189efce3e4dd79f66770357532f44e64ebd01c0d7d12642"
  license "MIT"
  head "https://github.com/sindresorhus/macos-wallpaper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1e914ea52d733357d9165fd9586312184db3424d25d9db45be2a1dbeea32113"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ead292c9e404b71f0a23c67b354e3243e291e10a0810005608c40da9e5b2027"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb3ddb10c7dd687056269894a21a80cc85e3889aab80eb9495b7c50d33a4336f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3e02c51455a71b426e091def47e0c0c2d5d77c885f7fe9fb18b760df6c8908b"
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
