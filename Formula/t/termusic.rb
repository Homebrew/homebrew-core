class Termusic < Formula
  desc "Music Player TUI written in Rust"
  homepage "https://github.com/tramhao/termusic"
  url "https://github.com/tramhao/termusic/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "686f66856d755f2d2056a9548f074b11ba9568ac8075fafd8903e332bf166227"
  license all_of: ["MIT", "GPL-3.0-or-later"]
  head "https://github.com/tramhao/termusic.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e3facb7042db6b4dd321d40077b8f19c1c4db1880fe2e1814555f573656cb44b"
    sha256 cellar: :any,                 arm64_sequoia: "d83195d661adccb98aebbb151861fe34cd51fdefe46865ea1da642d4195f8b41"
    sha256 cellar: :any,                 arm64_sonoma:  "ab04857bd9d272a05c41d7bad1cff3dda4926b96250c569452caf421012ea888"
    sha256 cellar: :any,                 sonoma:        "a63a6ab065346edc1f230305318ba7ca301b2c065c3fe6414f6f4bcc8c5eb774"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bb1fb574dd37e881471ae1eb8e8b027ae83ab1626d3aed9c8fae06568f7ac6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53a444e5a34adb183b14326f05c0f5a251d4e17e6e59d7d6cd2e4e4a397b2d24"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "opus"

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "alsa-lib"
    depends_on "libgccjit"
  end

  def install
    server_features = %w[rusty-libopus rusty-simd rusty-soundtouch]
    system "cargo", "install", *std_cargo_args(path: "tui")
    system "cargo", "install", *std_cargo_args(path: "server", features: server_features)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termusic --version")
    assert_match version.to_s, shell_output("#{bin}/termusic-server --version")

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"termusic", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn(bin/"termusic", [:out, :err] => output_log.to_s).last
    end
    sleep 1
    assert_match "Server process ID", output_log.read
  ensure
    # Use KILL to ensure the process terminates, as TERM request to confirm exiting program.
    Process.kill("KILL", pid)
    Process.wait(pid)
  end
end
