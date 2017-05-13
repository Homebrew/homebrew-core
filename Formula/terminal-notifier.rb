class TerminalNotifier < Formula
  desc "Send macOS User Notifications from the command-line"
  homepage "https://github.com/julienXX/terminal-notifier"
  url "https://github.com/julienXX/terminal-notifier/archive/1.8.0.tar.gz"
  sha256 "390ae441156c1c621c56ccb3cffa670ba74ee60762bbcf12c92686b749bf232e"
  head "https://github.com/julienXX/terminal-notifier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff749a3e3bf23b1c0830b5a9529ffab0b480d1d442ad2babe821e91d0af66eb2" => :sierra
    sha256 "17d17d143099cacf047751eb56a3f7397cf808f56311ccce6be03b784e60501b" => :el_capitan
    sha256 "16aefa24a26c812094ab13e66a9b87d38f5c26e23d6049e0c6d584dde9927afd" => :yosemite
  end

  depends_on :macos => :mountain_lion
  depends_on :xcode => :build

  def install
    xcodebuild "-project", "Terminal Notifier.xcodeproj",
               "-target", "terminal-notifier",
               "SYMROOT=build",
               "-verbose",
               "CODE_SIGN_IDENTITY="
    bin.install "build/Release/terminal-notifier"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/terminal-notifier -help")
  end
end
