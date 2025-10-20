class Zentropy < Formula
  desc "High-performance, lightweight key-value store server (Redis alternative)"
  homepage "https://github.com/mailmug/zentropy"
  url "https://github.com/mailmug/zentropy/releases/download/v1.0.0/zentropy.zip"
  sha256 "250cf01f3f86cf8607025f422c221e9f90c9824f1b4c53c2aed943a8b3a59aa4"
  license "MIT"

  def install
    # Extract the ZIP archive
    system "unzip", "zentropy.zip" if File.exist?("zentropy.zip")

    # Determine the right binary based on architecture
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "aarch64-macos/zentropty" => "zentropy"
      else
        bin.install "x86_64-macos/zentropty" => "zentropy"
      end
    elsif OS.linux?
      if Hardware::CPU.arm?
        bin.install "aarch64-linux-gnu/zentropty" => "zentropy"
      else
        bin.install "x86_64-linux-gnu/zentropty" => "zentropy"
      end
    else
      odie "Unsupported platform for Zentropy"
    end
  end

  test do
    system "#{bin}/zentropy", "--version"
  end
end
