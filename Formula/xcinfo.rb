class Xcinfo < Formula
  desc "Tool to get information about and install available Xcode versions"
  homepage "https://github.com/xcodereleases/xcinfo"
  url "https://github.com/xcodereleases/xcinfo/archive/0.7.0.tar.gz"
  sha256 "7d5c34c7c4deda28b101c747d89ca6535fd1d50ea26c957e50d18ebeea3da8bb"
  license "MIT"

  depends_on xcode: ["12.4", :build]
  depends_on macos: :catalina

  def install
    system "swift", "build",
           "--configuration", "release",
           "--disable-sandbox"
    bin.install ".build/release/xcinfo"
  end

  test do
    assert_match "12.3 RC 1 (12C33)", shell_output("#{bin}/xcinfo list --all --no-ansi")
  end
end
