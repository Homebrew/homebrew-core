class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
      :tag      => "v5.2.0",
      :revision => "ec748b51d016e42016c93f8df8acb5e8f3635ccc"
  head "https://github.com/mac-cain13/R.swift.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7616bf5ef6bb5d9c1f3d16993be16162bde9ff03b36a2d1bcb8363687ca9d35" => :catalina
    sha256 "0ddcb4899feef68f4b1bc7504670c226b22aa8bfcb4a8770add53f1df84a0d65" => :mojave
  end

  depends_on :xcode => "10.2"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
  end
end
