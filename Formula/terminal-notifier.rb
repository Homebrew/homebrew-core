class TerminalNotifier < Formula
  desc "Send OS X User Notifications from the command-line"
  homepage "https://github.com/julienXX/terminal-notifier"
  url "https://github.com/julienXX/terminal-notifier/archive/1.7.1.tar.gz"
  sha256 "6a322a01641d37ca11ed325452bcfce0b312c7bde65cd5afbb53236f1f6b51df"
  head "https://github.com/julienXX/terminal-notifier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b1654ff0e5b46b1fa6ff1e45688223d2e7c8c734d4b554a781d0b9be7fa5b59" => :sierra
    sha256 "5a1ddedfd70f41a1f4a04dc71637fc5f880318a6a66a8a22dcbb74338c6a2fba" => :el_capitan
    sha256 "fc8ffe7cd0c3a2e2503faab421d2504a25f37ace78367f549ffd1f72257aba36" => :yosemite
  end

  depends_on :macos => :mountain_lion
  depends_on :xcode => :build

  def install
    xcodebuild "-project", "Terminal Notifier.xcodeproj",
               "-target", "terminal-notifier",
               "SYMROOT=build",
               "-verbose"
    prefix.install Dir["build/Release/*"]
    inner_binary = "#{prefix}/terminal-notifier.app/Contents/MacOS/terminal-notifier"
    bin.write_exec_script inner_binary
    chmod 0755, bin/"terminal-notifier"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/terminal-notifier -help")
  end
end
