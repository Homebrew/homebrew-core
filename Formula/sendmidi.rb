class Sendmidi < Formula
  desc "Multi-platform command-line tool to send out MIDI messages"
  homepage "https://github.com/gbevin/SendMIDI"
  url "https://github.com/gbevin/SendMIDI/archive/1.0.2.tar.gz"
  sha256 "46ab36516b6d4ba022c4b57aa35c384ccd491c99993464e56bc317bc4748330b"

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "./Builds/MacOSX/sendmidi.xcodeproj", "-configuration", "Release", "SYMROOT=build"
    bin.install "./Builds/MacOSX/build/Release/sendmidi"
  end

  test do
    assert_match /Usage: sendmidi/, shell_output("#{bin}/sendmidi")
  end
end
