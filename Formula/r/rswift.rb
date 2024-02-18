class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/7.5.0/rswift-7.5.0-source.tar.gz"
  sha256 "4b5fa7bec4b064545ec76cfa0a312be932f78a1775a8b84cae3204a1ec93247a"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efe3eeac92249327c135ecfd20630dd807bb81ca9684fe8e3af00416a45c58e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04cbfe7cc830dd72eaac109a1433a1faed9d9eb8884633e0d58109e879dbfb88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9220b75e377a66ad28a362b0902b5ce8101552e1fd0d05af2a2309fef84575f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c30d107868450fe16d14363399f0854ce26981704a9badd7e343c23515a6c837"
    sha256 cellar: :any_skip_relocation, ventura:        "cffa219eb7873ef0bb049d890df55678f556ea6f47a00b62cbf5e0f4f3339b70"
    sha256 cellar: :any_skip_relocation, monterey:       "570563e46746c1656616d085c78736c058dd22f66891f37aa044799dd3b13ec7"
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
