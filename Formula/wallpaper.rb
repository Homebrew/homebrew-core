class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/v2.0.0.tar.gz"
  sha256 "49ab6121dcc78d17aae3219ceeeb1846792855179f11021192e5c42e500b166c"
  head "https://github.com/sindresorhus/macos-wallpaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9410db9144b8f500e4f17dae0e4f2ff81c905e5342d9c08d8d640a3955d297bf" => :mojave
    sha256 "67a9fe44fc315f659759a945f4a565813b9d206d4f0371945f6f905f9064bbc8" => :high_sierra
    sha256 "23528a4f9b7ac5486b3639ac0a9bf370f550a0c641dd2187947e78002a07896d" => :sierra
    sha256 "c41be619bf8adaf2e3472a2c25d1631afd3fcd70b83794184273fe6f3bdbe77c" => :el_capitan
    sha256 "7a715b58b8f4e654b409347fd8cff2bce6a3dfc83b0d345c3b83fc223eaf952a" => :yosemite
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :macos => :sierra

  def install
    system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib", "--disable-sandbox"
    bin.install ".build/release/wallpaper"
  end

  test do
    system "#{bin}/wallpaper", "get"
  end
end
