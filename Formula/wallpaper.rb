class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/v2.3.0.tar.gz"
  sha256 "96a7549b45aa166067a37099f6aaa6c2f5753c13225b1dd2cbea152ac7147818"
  license "MIT"
  head "https://github.com/sindresorhus/macos-wallpaper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59b1a600e7f99f62d72bfcac7082cd1047c365d712c618a8ec8059ff7197e360"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6042aa6f2ebf59f79bb6e598fe00b0d8237803a2a39185ea51c1f7fe0be0041"
    sha256 cellar: :any_skip_relocation, monterey:       "29bd8a9f785c73f329e74a36046dad21a4ed89a1a2a6e53098c5eba0334f7d0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dcb44f399a5873fc92c16e8e1d30797e9501c68ccd2ff61b0651b8975e0c73e"
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
