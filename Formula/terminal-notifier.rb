class TerminalNotifier < Formula
  desc "Send macOS User Notifications from the command-line"
  homepage "https://github.com/julienXX/terminal-notifier"
  url "https://github.com/julienXX/terminal-notifier/archive/2.0.0.tar.gz"
  sha256 "6f22a7626e4e68e88df2005a5f256f7d3b432dbf4c0f8a0c15c968d9e38bf84c"
  license "MIT"
  head "https://github.com/julienXX/terminal-notifier.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20ebb413679d76521e4434cb4351560f35052985a11cbb1f85c12e45bef95919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9862b6cf8d3b299ef67dcfb6e31d3040670bdfe58110d04797b117b3702de42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1268e236f13f5bb4cd5fead9cf54cfb54ceefb98e34861bd39cf3c7e6ef34cf"
    sha256 cellar: :any_skip_relocation, ventura:        "29c41b914cd8299dba529d1fc6029e4af981ee90010f8a8b11dc4ded8e097855"
    sha256 cellar: :any_skip_relocation, monterey:       "6513db788b33570b1b89d2b0215e3176d629814b3233c993e995ec9806ad32df"
    sha256 cellar: :any_skip_relocation, big_sur:        "91f14694ebce08887492aa75138753cd9ff74977868927b15b52559728280055"
    sha256 cellar: :any_skip_relocation, catalina:       "78eff95b7436480521ee68a8581ff2df0c615adefccd279486f2491f1b1c0a4b"
    sha256 cellar: :any_skip_relocation, mojave:         "9671c602326357b7397248bfb0cf062bc47f19add15b615e512f58545c387c31"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f112656234f4100d23cc1a41b96f92a09974360a822c2ec0fb6f9970862c1a22"
    sha256 cellar: :any_skip_relocation, sierra:         "210cd525fad70bbaef40f092bc3478b1519f68f73c034990230d8b1cc61a8a7c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "75ce68fd95fb502e20ccb25be72f7db12112ac1a4bdf5a70c140cd174ecbacf5"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "Terminal Notifier.xcodeproj",
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
