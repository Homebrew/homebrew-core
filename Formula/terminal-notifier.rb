class TerminalNotifier < Formula
  desc "Send macOS User Notifications from the command-line"
  homepage "https://github.com/julienXX/terminal-notifier"
  url "https://github.com/julienXX/terminal-notifier/archive/1.8.0.tar.gz"
  sha256 "390ae441156c1c621c56ccb3cffa670ba74ee60762bbcf12c92686b749bf232e"
  head "https://github.com/julienXX/terminal-notifier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "09526513aedc26828fa7f0353d382c6cd19eb66382bf8f7be2e767ccd8ac03d0" => :sierra
    sha256 "cca0ee4445296598ab334cd281db3937c8d5b228e52791347156f8e81872000a" => :el_capitan
    sha256 "5516223480fae238c8056e56763ca1613e45052f9cc681d3da56f59afc319675" => :yosemite
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
