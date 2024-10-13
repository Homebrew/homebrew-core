class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/7.7.0/rswift-7.7.0-source.tar.gz"
  sha256 "0886dcb46b33fe99cd800e0bc50dd1f097e007aa40c5480a3b545732f500c1f7"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1460dc8f90ef7644614da9821e8d7cf62cfa5b6cb1c81dc53f6cf826d9d069db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53c39fd3fc24c8032635dacc897806355e714248b0b578d7da5a589350d48994"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6a270ca10a5b70e0bfb2c68d121685d40e74b17a6a52832dcb6635fb8ac9ca3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2bd81e6d5e1b476bf50515bde6ace9b2a9a1fde00cbbec691f0c4f0d84fd15c"
    sha256 cellar: :any_skip_relocation, ventura:       "609fae158de18f1bc94cecad8f424640339c5673fccfc4fcbb77911ccd36ddbd"
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
