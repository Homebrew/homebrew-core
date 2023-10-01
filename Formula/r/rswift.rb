class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/7.4.0/rswift-7.4.0-source.tar.gz"
  sha256 "0f9c88a46b826d0e6bbb1e9a73edc5039013d43b78948bb286e6a879959d2a9d"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d451507fc8e00f6bed6d156b2138c86378454b2e10ebb0c8d0c48d27a1f51a0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6761c81018971df341d852b13ebfcf94845897352b09e0fc63e378801ba4ef2f"
    sha256 cellar: :any_skip_relocation, ventura:        "c9aa20b05c383ca493bc96d793d173efa77fa267706f4243a9a79a6ad68db310"
    sha256 cellar: :any_skip_relocation, monterey:       "c3e8ac7f82bda6f2140cb3aee08d34aecc53ae3c0c9e422b6d303fe48049c899"
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
