class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.16.1.tar.gz"
  sha256 "2a015af9e501eeabfae72033e91620365c1ebdf4dc401ae2971081d479b6186b"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d69bcf5e6dcf69247e53f67b58d568fbff5219b0d98683db24c2e2c6d60f71cd" => :mojave
    sha256 "8e030ca0e08585b2c58db2504da93631a754dd38331615d12350ac8a1873ca33" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", "-target", "-Xswiftc", "x86_64-apple-macosx10.11"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
