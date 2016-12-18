class Slash < Formula
  desc "Slack terminal client written in Swift."
  homepage "https://github.com/slash-hq/slash"
  url "https://github.com/slash-hq/slash/archive/0.1.0.tar.gz"
  sha256 "8a709579ffba7c47b1e1975bb418d72ecbd542539d4cd6f7a72d876808bfbdb2"

  depends_on :xcode
  def install
    xcodebuild "-workspace", "slash.xcodeproj/project.xcworkspace", "-derivedDataPath", "prefix.to_s", "-configuration", "Release", "-scheme", "slash", "SYMROOT=#{prefix}/Build"
    bin.install(prefix + "Build/Release/slash")
  end

  test do
    system "false"
  end
end
