class Vizb < Formula
  desc "Transform Go, Rust, and JavaScript benchmark output into interactive 4D visualizations"
  homepage "https://vib.goptics.org"
  version "0.11.0"
  license "MIT"
  head "https://github.com/goptics/vizb.git", branch: "main"
  
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goptics/vizb/releases/download/v0.11.0/vizb@0.11.0-darwin-arm64.tar.gz"
      sha256 "1096b14e39dcf7fb12e5297fe881f17140c39ac6e96bbaf47ecd00ae9e5267a7"
    else
      url "https://github.com/goptics/vizb/releases/download/v0.11.0/vizb@0.11.0-darwin-amd64.tar.gz"
      sha256 "6993b6645650b5f803c9d8f62305265c0be9d9d3d9416f555c2cd9a1f8e51357"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/goptics/vizb/releases/download/v0.11.0/vizb@0.11.0-linux-arm64.tar.gz"
      sha256 "e5e8131fab7c783ae75f225f2c551bd96bcbcc7a77f364b8a0b9b203967df644"
    else
      url "https://github.com/goptics/vizb/releases/download/v0.11.0/vizb@0.11.0-linux-amd64.tar.gz"
      sha256 "8a5e50771c2374853a03e557372cc892057d3c74e2cb2f4ec1491f7ec8099180"
    end
  end

  def install
    bin.install "vizb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vizb")
  end
end
