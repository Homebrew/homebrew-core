class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/v6.1.0/rswift-v6.1.0-source.tar.gz"
  sha256 "f4b4c3f8748358c569c219d7f506d3b34ea5af82c882ee4a23381f23c4d277c8"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a609e1a2f866c2b1d08ae2fb5114a182ba5a87a91f745202b8a0de67eadb3e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2db2bde39d2e583b5982869ea8c25696909cd83b82fece0ea41f7c6809702459"
    sha256 cellar: :any_skip_relocation, monterey:       "9d743c8f7a78919017ea4835de73d385e9fd04b9291aedd27ae7cba0e827cafd"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb0930087125bb968caaa02eee28f21d9643def376de811c7b72aac874eed85b"
    sha256 cellar: :any_skip_relocation, catalina:       "5fa3a697f9af414e62a11567311054687c3805c3d4220ec9105639f439d92936"
  end

  depends_on :macos # needs CoreGraphics, a macOS-only library
  depends_on xcode: "10.2"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
    expected_output="[R.swift] Missing value for `PROJECT_FILE_PATH`"
    assert_match expected_output, shell_output("#{bin}/rswift generate #{testpath} 2>1&")
  end
end
