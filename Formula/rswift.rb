class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/v5.2.2/rswift-v5.2.2-source.tar.gz"
  sha256 "b27c51e9c69adcc61ed2f8a476fa5f2d97be5996d4f1e59a0e1b754a58980e26"
  head "https://github.com/mac-cain13/R.swift.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45db5b001da5af79ee047da3496a89e430f458ec83a57d68c0da696c4b8b2e29" => :catalina
    sha256 "479d11f836c09faf090901c3326da1d5cd1d0f545be691e6c3bddb47d931eda9" => :mojave
  end

  depends_on :xcode => "10.2"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
    assert_match "[R.swift] Failed to write out", shell_output("#{bin}/rswift generate #{testpath} 2>1&")
  end
end
