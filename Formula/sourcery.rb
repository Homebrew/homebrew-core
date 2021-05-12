class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.4.2.tar.gz"
  sha256 "2ff6b435955ec4e44e007c32fdcea35c25fe2d6336d19e613c889912c01b8b58"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5772d310fcfa35cbfc4728014bdd9209729582105889baf5cdead1c1f0d15cda"
    sha256 cellar: :any, big_sur:       "ae123c832a67f5f9b653aa112bbbbada462a86779571382daf4281e702044dde"
    sha256 cellar: :any, catalina:      "f5bddc31cd6b8906671660775fdfb255e43f6f12cfffce7136784b891008cf19"
  end

  depends_on xcode: "12.0"
  uses_from_macos "ruby" => :build

  def install
    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
