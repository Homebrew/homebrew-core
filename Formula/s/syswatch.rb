class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/syswatch"
  url "https://github.com/matthart1983/syswatch/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "660855f2d03dbc5cea6921a0ebd66b97d55eac3b83c27bef525802c9f189668d"
  license "MIT"
  head "https://github.com/matthart1983/syswatch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db019de70464fb8269a825c681762180b7a1eebaa7d0d9c6ec955e53423241b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3ed48b9df8e6893c22f52418d978744ac269fca7a396fd7ed895be50bc9c752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "beb22ff345fa2f068c28b781c284f4cdf60e5c56c3f3118f864ada20fd786e7a"
    sha256 cellar: :any,                 arm64_linux:       "d5b353daee68e216f32e8937a92492d2f0f01ac147231c22a56f5dead2e9e9ed"
    sha256 cellar: :any,                 x86_64_linux:      "918cf7771d17eee0ac5161ba06f190c17b15eb62a048ab8cb50cd2eae796bc9e"
  end

  depends_on "rust" => :build

  on_macos do
    depends_on arch: :arm64 # test fails on Intel macOS
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
