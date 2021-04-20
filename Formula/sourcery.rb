class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.4.1.tar.gz"
  sha256 "a02ffb9ddae4ac8f7fef12c2898733b81509100f14e085409752fb4240f12167"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "abacda61686eb9aac087eded93bd4f3d8384a2df4b07eb25f5db1bf42cb71081"
    sha256 cellar: :any, big_sur:       "ea9749813c93e9abecb0953910efd402aa556f94edc0bb3d41d5ba2213422608"
    sha256 cellar: :any, catalina:      "648fba6896d186b3d28a6b19f0b2cf6e70ff74554f9cd412539d765c12e63487"
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
