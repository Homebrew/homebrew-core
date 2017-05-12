class TerminalNotifier < Formula
  desc "Send macOS User Notifications from the command-line"
  homepage "https://github.com/julienXX/terminal-notifier"
  url "https://github.com/julienXX/terminal-notifier/archive/1.7.2.tar.gz"
  sha256 "64287240ec31dab01c7d1f250f58e48a454607785d2b6fbb91a84d862958f8d3"
  head "https://github.com/julienXX/terminal-notifier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4dd06d3c8f082fe3c8246e784661e86fdb7986cdaa9fe65638ba472ef8f43f4" => :sierra
    sha256 "7fad6587bf48c9956c1b0c3ec691a549a34a829850069809b2e3af91710ee5a8" => :el_capitan
    sha256 "2eddadf3bcd3edbfd962325bf5eb4be41f2a3bef8e1305ed48a922c9fe02d027" => :yosemite
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
