class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/7.3.0/rswift-7.3.0-source.tar.gz"
  sha256 "07fe240a92076255d909f7bcfba5eea842820fd7185bb7541e24699c5211a59c"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "279c8d49ed003903fcd411f13e96853833acc3c166e9a51c26c681f3a7961df6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f6905779476ea9ef646075c787afb0df60f43fbd18bd83441d17609eb750c63"
    sha256 cellar: :any_skip_relocation, ventura:        "39d05b5f6965c3ee7c46bbe31f375819e7210e6c09fd1c73327ddbd4d4dce5d7"
    sha256 cellar: :any_skip_relocation, monterey:       "b6f6ce17bd46e84b622610798265959f74bef5c5f0b9c17c02ec188cc3fa13e1"
  end

  depends_on :macos # needs CoreGraphics, a macOS-only library
  depends_on xcode: "13.3"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
    expected_output="Error: Missing argument PROJECT_FILE_PATH"
    assert_match expected_output, shell_output("#{bin}/rswift generate #{testpath} 2>&1", 64)
  end
end
