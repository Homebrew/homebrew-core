class Termusic < Formula
  desc "Music Player TUI written in Rust"
  homepage "https://github.com/tramhao/termusic"
  url "https://github.com/tramhao/termusic/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "661e1c39135f6eeb01cb6df199b8dcdd902ac456e96bd204ea4fda7ec6ae41ef"
  license all_of: ["MIT", "GPL-3.0-or-later"]
  head "https://github.com/tramhao/termusic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "849a8e2baf136452070b25f3f41f9b1e5ca2a13d42e52c2cc4f3d4343caa236d"
    sha256 cellar: :any,                 arm64_sequoia: "a4a71b8e4eb7daaf98313a4b773c124334c2d08662cf6ff7a9ab6576a7965482"
    sha256 cellar: :any,                 arm64_sonoma:  "d746ca41ae4e7e5fe17ed7179922ac79c86b7485556cc9937824b7309c2d9366"
    sha256 cellar: :any,                 sonoma:        "72a694587aab41e4482759d5da0652853d60505467125bebdfb6dbfc23cd8b46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "294ca981f0d206a9bc8a960c4cda0206d6ec9da0de34622ed09b60f679f27a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9260de245136bc641b94a891a0bdb97cf41b7e1e58485fcc65c666ab1827591a"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "alsa-lib"
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
