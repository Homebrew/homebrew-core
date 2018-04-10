class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.11.2.tar.gz"
  sha256 "0be23addc7ae986158cbef263393539f9e07f67969a1d51b82aec78cb7d0d21a"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a9b2c78ce0029175aebcd204dea5f68506328cf9223168b04b7e2bd6df70edf" => :high_sierra
    sha256 "08040bff659f7a1cdd8deb115c3a0996413c443f133917d223eb3f7356c7b8ad" => :sierra
  end

  depends_on :xcode => "6.0"
  depends_on :xcode => ["8.3", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
