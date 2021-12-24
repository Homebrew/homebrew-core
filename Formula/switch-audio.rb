class SwitchAudio < Formula
  desc "Simple command-line utility for switching audio inputs and outputs on macOS"
  homepage "https://github.com/hladik-dan/switch-audio"
  url "https://github.com/hladik-dan/switch-audio/archive/refs/tags/1.0.0.tar.gz"
  sha256 "8e6f45698d05ecb4a0a5a03dce21cbb28d6cc3c977998117278b93222b710b4f"
  license "MIT"
  head "https://github.com/hladik-dan/switch-audio.git", branch: "main"

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild  "-project", "switch-audio.xcodeproj",
                "-target", "switch-audio",
                "-configuration", "Release",
                "-arch", Hardware::CPU.arch,
                "SYMROOT=build",
                "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/switch-audio"
  end

  test do
    system "#{bin}/switch-audio", "--list"
  end
end
