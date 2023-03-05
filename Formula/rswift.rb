class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/7.3.0/rswift-7.3.0-source.tar.gz"
  sha256 "07fe240a92076255d909f7bcfba5eea842820fd7185bb7541e24699c5211a59c"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f070f8ef57caba4f93c38a5f60d0c0fdac457289949a50b66007ed477d281043"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51a4e6c8e8cc24590966f9a02b8e13a089f143770ecc8217224f42a758268efd"
    sha256 cellar: :any_skip_relocation, ventura:        "81e656fc368c7bddbca9a095518bca63c4d11408c274d558fd26e6313952f2d3"
    sha256 cellar: :any_skip_relocation, monterey:       "2514bf9e6e8a9fe4e3e84ec13af6606dc6bb5ac23bba6e273a6b63aa65e2c49b"
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
