class Soundscope < Formula
  desc "TUI for real-time analysis of audio files, system audio, and microphone input"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "e5bdd0ff58b6c3a0e55213750105e8d9638f16f01cee6740c5f13573091daf70"
  license "MIT"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Usage", shell_output("#{bin}/soundscope --help")
    assert_match version.to_s, shell_output("#{bin}/soundscope --version")
  end
end
