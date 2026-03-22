class Termusic < Formula
  desc "Music Player TUI written in Rust"
  homepage "https://github.com/tramhao/termusic"
  url "https://github.com/tramhao/termusic/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "686f66856d755f2d2056a9548f074b11ba9568ac8075fafd8903e332bf166227"
  license all_of: ["MIT", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c2f883e043839db16ac4f8de8add8b972de0e008463f714e7a19c89cb76be45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87d7b2e39b0809ee26208e482ee7f85dea70d69b70a62833c526b4be18d76e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9438afa2b260b4345bc0bde7c106fb3c2d5cb698cd4df6503d4bed74453c518c"
    sha256 cellar: :any_skip_relocation, sonoma:        "06be1c021c63e361e292860592fb21b6abe48f044e8fcba7dc74740ce29d9069"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c32e8c19f96b03217bdca10746787eaf5d000fea12be63e769c6985385604bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4723e83582af2d07546b8af198ee691299a3bfb4e10dd55003391556ecc6f508"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "sound-touch" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tui", features: "cover-viuer-iterm")
    system "cargo", "install", *std_cargo_args(path: "server")
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
