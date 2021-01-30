class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.0.3.tar.gz"
  sha256 "af6e3549fba9b734a667343f5b888f2226e9a2e4e462fe81bfc2cbef67421251"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur: "209fe3b3b20d70cfa1aba74e331290aea890b504589747d878cd2a4df72c29c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "69c490f59804052c65b2545e9b70207711a2bd2c106d03352c07f97776fc4d87"
    sha256 cellar: :any_skip_relocation, catalina: "e10c57ece8ee87b221661d19417f50fcea520bcc8291186fe78ff1bed9996a66"
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
