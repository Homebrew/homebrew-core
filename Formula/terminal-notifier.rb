class TerminalNotifier < Formula
  desc "Send macOS User Notifications from the command-line"
  homepage "https://github.com/julienXX/terminal-notifier"
  url "https://github.com/julienXX/terminal-notifier/archive/2.0.0.tar.gz"
  sha256 "6f22a7626e4e68e88df2005a5f256f7d3b432dbf4c0f8a0c15c968d9e38bf84c"
  head "https://github.com/julienXX/terminal-notifier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "78eff95b7436480521ee68a8581ff2df0c615adefccd279486f2491f1b1c0a4b" => :catalina
    sha256 "9671c602326357b7397248bfb0cf062bc47f19add15b615e512f58545c387c31" => :mojave
    sha256 "f112656234f4100d23cc1a41b96f92a09974360a822c2ec0fb6f9970862c1a22" => :high_sierra
    sha256 "210cd525fad70bbaef40f092bc3478b1519f68f73c034990230d8b1cc61a8a7c" => :sierra
    sha256 "75ce68fd95fb502e20ccb25be72f7db12112ac1a4bdf5a70c140cd174ecbacf5" => :el_capitan
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "Terminal Notifier.xcodeproj",
               "-target", "terminal-notifier",
               "SYMROOT=build",
               "-verbose",
               "CODE_SIGN_IDENTITY="
    prefix.install "build/Release/terminal-notifier.app"
    bin.write_exec_script prefix/"terminal-notifier.app/Contents/MacOS/terminal-notifier"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/terminal-notifier -help")
  end
end
