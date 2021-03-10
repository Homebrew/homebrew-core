class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.3.3.tar.gz"
  sha256 "edd44bea2620b65e990e69c30a0a717ec4e5626fb7a07bc999ac42b50de72489"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f6186fac3f0b111e58a47057c391dae0e47f6d1fd28757177933122fcb2412f4"
    sha256 cellar: :any, big_sur:       "6013f5e37a095e05826d2d445421e2e6c1c4a2047f82f3234171c9272f6e9690"
    sha256 cellar: :any, catalina:      "02fcd591f3b7acb4481603aa442d22049aa1215c46b9b0506b59bc4fc416c24a"
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
