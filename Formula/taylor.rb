class Taylor < Formula
  desc "Measure Swift code metrics and get reports in Xcode and Jenkins."
  homepage "https://github.com/yopeso/Taylor/"
  url "https://github.com/yopeso/Taylor/archive/0.2.1.tar.gz"
  sha256 "ecbc7701120910c18384e1a255b65e5cb0d495f0f02188d76279e3b70850c362"
  head "https://github.com/yopeso/Taylor.git"

  bottle do
    cellar :any
    sha256 "e1a5732e18eb6d7ab3f4edaf6dd44ad1f32c9c0aadf5e6e6e1b935c67a58090e" => :sierra
    sha256 "727ffd784c84a38377de5cc2576741a1dc96fc05786772d15bf36b7d0a77f689" => :el_capitan
  end

  depends_on :xcode => ["8.1"]

  def install
    system "make", "install", "PREFIX=#{prefix}", "MAKE_SYMLINKS=no"
  end

  test do
    # Improve test once sandbox issues have been resolved:
    # https://github.com/Homebrew/legacy-homebrew/pull/50211
    assert_match version.to_s, shell_output("#{bin}/taylor --version")
  end
end
