class Xcinfo < Formula
  desc "Tool to get information about and install available Xcode versions"
  homepage "https://github.com/xcodereleases/xcinfo"
  url "https://github.com/xcodereleases/xcinfo/archive/0.7.0.tar.gz"
  sha256 "7d5c34c7c4deda28b101c747d89ca6535fd1d50ea26c957e50d18ebeea3da8bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b49e2ca52261772a4f1116291d7906d045659797b2ee7fa7fd419417fbd66034"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d719be8c45d3b7e6c1eb45b7a9df9245412c61bd5fe972553e6461fa6cf6bc2e"
    sha256 cellar: :any_skip_relocation, monterey:       "0ea284f5a8d412b352148c7e538443d1a9f1031c27d52f3004a7f513e2963736"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c1e12e54fa12699b44eb96b3053c44826fc197210e08a195d5f9913ea6592ae"
    sha256 cellar: :any_skip_relocation, catalina:       "4cd605c355e9c18be2219e5b459847673066ada976afee46c49f4b667c91fba5"
  end

  depends_on xcode: ["12.4", :build]
  depends_on macos: :catalina
  depends_on :macos

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
