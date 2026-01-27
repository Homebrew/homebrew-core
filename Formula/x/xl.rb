class Xl < Formula
  desc "A fast, terminal-based spreadsheet application written in Rust"
  homepage "https://rustxl.com"
  version "0.1.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/only-using-ai/rustxl/releases/download/v0.1.2/xl-macos-x86_64.tar.gz"
      sha256 "c8dc41a5687a8cf66934ff0dd170b097a447f3cbdec60b05321eb7e8e235d6fd"
    else
      url "https://github.com/only-using-ai/rustxl/releases/download/v0.1.2/xl-macos-arm64.tar.gz"
      sha256 "70c0873f00d32e8bdf690c49183da2c39967354c7369743aa572023b7494f073"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/only-using-ai/rustxl/releases/download/v0.1.2/xl-linux-x86_64.tar.gz"
      sha256 "cd9325340744d2a98d905d3836094b11a7339f0f8a20823b990a6ffe313e78ab"
    else
      url "https://github.com/only-using-ai/rustxl/releases/download/v0.1.2/xl-linux-aarch64.tar.gz"
      sha256 "ffc879cd183b06e770f641ce757856fd31d606c36076a481f4cf2c29e985dff8"
    end
  end

  def install
    bin.install "xl"
  end

  test do
    assert_predicate bin/"xl", :exist?
    assert_predicate bin/"xl", :executable?
  end
end
