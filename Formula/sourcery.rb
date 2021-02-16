class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.2.1.tar.gz"
  sha256 "a37c249c6685350a08ae18c4a223ac7370299b530a309fd10b5fb088aa71200d"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4cee4c391628bf3b03420cc83b62aa81404b4be9bfa058d13dfc1d6220a3fea4"
    sha256 cellar: :any_skip_relocation, big_sur:       "a7a4609988ba6f890a9a96cab4ee94777b740aed1786241ea8ab818e66ab7c65"
    sha256 cellar: :any_skip_relocation, catalina:      "d7caf63356f1df5977bc2452590144f794763388d4beecc49697735f98c9b7a7"
  end

  depends_on xcode: "12.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/sourcery"
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
