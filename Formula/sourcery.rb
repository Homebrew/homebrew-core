class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.16.2.tar.gz"
  sha256 "a04ca9958d8a3d4570059cd71b3df1fda8db27027ef1340f28449a94f8e9ccc8"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d69bcf5e6dcf69247e53f67b58d568fbff5219b0d98683db24c2e2c6d60f71cd" => :mojave
    sha256 "8e030ca0e08585b2c58db2504da93631a754dd38331615d12350ac8a1873ca33" => :high_sierra
  end

  depends_on :xcode => "10.2"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", "-target", "-Xswiftc", "x86_64-apple-macosx10.11"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
