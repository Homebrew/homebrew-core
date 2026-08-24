class TerminalNotifier < Formula
  desc "Send macOS User Notifications from the command-line"
  homepage "https://github.com/julienXX/terminal-notifier"
  url "https://github.com/julienXX/terminal-notifier/archive/refs/tags/3.0.0.tar.gz"
  sha256 "ed6463d38166785fd5db70b7b7063b276d4d376bbe714784d372b29f952c52bd"
  license "MIT"
  head "https://github.com/julienXX/terminal-notifier.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "921a84b3b65356359a6961c9ab61d22e3f590cb0c1ead5df8084b7af5bac623e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f0b0d837ef0a64cbbe1c6dff4865149897eb97e37e05181d1193db2788b6067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74f1340c27d4714414a23fd61401e35c290303ff8f8a99bd10f9b31b6511f607"
    sha256 cellar: :any_skip_relocation, sonoma:        "75d0ea18fea636edcef8b8638d0d250b6053680e289bcb67bd60fc97db087ca0"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "Terminal Notifier.xcodeproj",
               "-target", "terminal-notifier",
               "SYMROOT=build",
               "-verbose",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
               "CODE_SIGN_IDENTITY="
    prefix.install "build/Release/terminal-notifier.app"
    bin.write_exec_script prefix/"terminal-notifier.app/Contents/MacOS/terminal-notifier"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/terminal-notifier -help")
  end
end
