class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/syswatch"
  url "https://github.com/matthart1983/syswatch/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "390c0bf558e8c1859ffb77e05dcce47f7af073b26a38fc8800129c2d550ff44a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5662b621595ea2ca0331e9c2dc1ef87785f98446bbaac0199bbcd613868d8875"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b87ff4233bba0b6753be2b059940ca3371c887f49a8aba1ac13b50a00016e35d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55e278e3c176d66e5244d80865d6f4b996774a9ca913a60c35f67f13cd103338"
    sha256 cellar: :any,                 arm64_linux:       "ba7f9644499273d68ac2c409b93f6fb60741738867efb69b5f03165f0c205d6c"
    sha256 cellar: :any,                 x86_64_linux:      "f46eae8eec42570e16604e8f3a6d4a5cc6669aef2e0e64bccbb69bedcfcbfa4f"
  end

  depends_on "rust" => :build

  on_macos do
    depends_on arch: :arm64 # test fails on Intel macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    ENV["TERM"] = "xterm"
    output_log = testpath/"output.log"
    PTY.spawn(bin/"syswatch", [:out, :err] => output_log.to_s) do |r, w, pid|
      r.winsize = [80, 130]
      sleep 2
      # bring up help dialog
      w.write "?"
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    output = output_log.read.scrub
    assert_match "Services", output
    # match text in help dialog
    assert_match "Procs tab", output
  end
end
