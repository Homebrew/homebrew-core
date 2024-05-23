class vedic < Formula
  desc "vedic-lang is a Sanskrit programming language"
  homepage "https://github.com/vedic-lang/vedic"
  version "2.0.6"
  license "MIT"
  head "https://github.com/vedic-lang/vedic.git", branch: "main"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vedic-lang/vedic/releases/download/v#{version}/vedic-darwin-aarch64.tar.gz"
      sha256 "bbd827b70e20b8ac1821b5e56d9fa5e7195327ea50a71df912c3088795b1384e"
    elsif Hardware::CPU.intel?
      url "https://github.com/vedic-lang/vedic/releases/download/v#{version}/vedic-darwin-x86_64.tar.gz"
      sha256 "bbd827b70e20b8ac1821b5e56d9fa5e7195327ea50a71df912c3088795b1384e"
    else
      # Unsupported platform
      odie "This platform is not supported."
    end
  elsif OS.linux?
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/vedic-lang/vedic/releases/download/v#{version}/vedic-linux-gnu-aarch64.tar.xz"
      sha256 "bbd827b70e20b8ac1821b5e56d9fa5e7195327ea50a71df912c3088795b1384e"
    elsif Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/vedic-lang/vedic/releases/download/v#{version}/vedic-linux-gnu-x86_64.tar.xz"
      sha256 "bbd827b70e20b8ac1821b5e56d9fa5e7195327ea50a71df912c3088795b1384e"
    elsif Hardware::CPU.intel? && Hardware::CPU.is_32_bit?
      url "https://github.com/vedic-lang/vedic/releases/download/v#{version}/vedic-linux-gnu-i686.tar.xz"
      sha256 "bbd827b70e20b8ac1821b5e56d9fa5e7195327ea50a71df912c3088795b1384e"
    elsif Hardware::CPU.arm? && Hardware::CPU.is_32_bit?
      url "https://github.com/vedic-lang/vedic/releases/download/v#{version}/vedic-linux-gnueabihf-armv7.tar.xz"
      sha256 "bbd827b70e20b8ac1821b5e56d9fa5e7195327ea50a71df912c3088795b1384e"
    elsif Hardware::CPU.intel? && Hardware::CPU.is_64_bit? && OS::Linux::Musl.is_detected?
      url "https://github.com/vedic-lang/vedic/releases/download/v#{version}/vedic-linux-musl-x86_64.tar.xz"
      sha256 "bbd827b70e20b8ac1821b5e56d9fa5e7195327ea50a71df912c3088795b1384e"
    else
      # Unsupported platform
      odie "This platform is not supported."
    end
  else
    # Unsupported platform
    odie "This platform is not supported."
  end

  def install
    bin.install "vedic"  # Install the binary
  end

  def caveats
    <<~EOS
      To get started, run:
        vedic --help
    EOS
  end

  test do
    # Simple test to verify the binary is installed
    assert_match "Usage:", shell_output("#{bin}/vedic --help")
  end
end