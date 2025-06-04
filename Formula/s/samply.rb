class Samply < Formula
  desc "Command-line sampling profiler for macOS and Linux"
  homepage "https://github.com/mstange/samply"
  version "0.13.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/mstange/samply/releases/download/samply-v0.13.1/samply-aarch64-apple-darwin.tar.xz"
      sha256 "7597239aa3769e75058be5ed359dbfe067f5e7714a5f052c45dd81d509aec17f"
    else
      url "https://github.com/mstange/samply/releases/download/samply-v0.13.1/samply-x86_64-apple-darwin.tar.xz"
      sha256 "a57f05f9162d06c36df6d51425d976ac774a8cd6dbd84050e6303fa8bf813998"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/mstange/samply/releases/download/samply-v0.13.1/samply-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61875daad67888798690dea3cb2748279df6ac299c5c6a857d67eed7642473d9"
    else
      url "https://github.com/mstange/samply/releases/download/samply-v0.13.1/samply-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa465162b62830168775b7ff4804bc35049436dcbc29bb3d1ea9f580380ea06a"
    end
  end

  def install
    bin.install "samply"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/samply --version")
  end
end
