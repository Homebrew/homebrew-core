class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/7.8.0/rswift-7.8.0-source.tar.gz"
  sha256 "6288a8e12aa6de24d8689c3483400bb0cde85f932c130459405f0c3be4886794"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03c1c4c066560ead4096db89baa3667cb8c4c346f7ccdb590316b78402e7fa2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88a2e680ddf7ee98e93c7f65b45cf5cb57d75a98bfda53da1532a93d75593091"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "978a3efc5b0687c959f30ba02cd634413d93ef0a175e042e8d8cb308fa6b3382"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55e047c896dd29af0770cc078e0de6535a54b3794d98bb3ef8218b496c7f1bc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "dff1efc08234604ae33b0fb75e0b70f3df7b694caced22ae33366a1fec3db047"
    sha256 cellar: :any_skip_relocation, ventura:       "953d9d6d661625561249978b25d215afa4198af17a6e7ea866981be0fa5cbdbd"
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
