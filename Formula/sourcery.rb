class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.4.0.tar.gz"
  sha256 "a735ea332ca62af592ca5a09e5195767fd5d83242b8274bc0c6fc45387efe569"
  license "MIT"
  revision 1
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "119babe36b16fcf0b5b15cd346a46f5ffe6ac605213a65de073d6b49a02346b3"
    sha256 cellar: :any, big_sur:       "d92c19b4378d014eef67c4632b1ca7103bb5d218d24315147301f6362c89593b"
    sha256 cellar: :any, catalina:      "9abcc985fd21879613a1841c35864a9ea103552603892040b3b21113f59b8d7d"
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
