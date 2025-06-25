# Homebrew formula for Vibe-Guard
# This formula handles installation of Vibe-Guard on macOS and Linux systems
class VibeGuard < Formula
  # Basic package information
  desc "🛡️ Security scanner for developers who code fast"
  homepage "https://github.com/Devjosef/vibe-guard"
  version "1.0.1"
  license "MIT"
  head "https://github.com/Devjosef/vibe-guard.git", branch: "main"

  # Platform-specific download URLs and checksums
  if OS.mac?
    # macOS ARM64 (Apple Silicon) specific configuration
    if Hardware::CPU.arm?
      url "https://github.com/Devjosef/vibe-guard/releases/download/v#{version}/vibe-guard-macos-arm64"
      sha256 "0b80a08ad3d8ec69c2ab1da72c5d6f3ce64948b67a3f39dbc614a4b701ef7289"
    # macOS Intel specific configuration
    else
      url "https://github.com/Devjosef/vibe-guard/releases/download/v#{version}/vibe-guard-macos-x64"
      sha256 "39c1adfed38916a9562da383793865c2a30e3f44ce265bbbd30e2d0ba8647429"
    end
  elsif OS.linux?
    # Linux ARM64 specific configuration
    if Hardware::CPU.arm?
      url "https://github.com/Devjosef/vibe-guard/releases/download/v#{version}/vibe-guard-linux-arm64"
      sha256 "ee8bc14609e77716b7006f49fc30b1f75f0dbaddd884693cf3a7c7594a038f1d"
    # Linux AMD64 specific configuration
    else
      url "https://github.com/Devjosef/vibe-guard/releases/download/v#{version}/vibe-guard-linux-x64"
      sha256 "c455f9f9e95b4a0d0dda36a2573beae6ea9dc18d5394ea4da040dbf542250868"
    end
  end

  # Installation method
  # This method is called during installation to place the binary in the correct location
  def install
    bin.install "vibe-guard"  # Install the binary to Homebrew's bin directory
  end

  # Test method
  # This method is called during installation to verify the installation
  test do
    system "#{bin}/vibe-guard", "--version"  # Verify the binary works
  end

  # Add caveats about the open source nature
  def caveats
    <<~EOS
      Vibe-Guard is an open source project maintained by Josef and the Vibe-Guard community.
      For more information, visit: https://github.com/Devjosef/vibe-guard
    EOS
  end
end 